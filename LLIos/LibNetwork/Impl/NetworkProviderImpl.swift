import Alamofire
import LibSwift
import LibNetwork
import Foundation
import FactoryKit
import Settings
import AccountStorage
import Logger

actor NetworkProviderImpl: NetworkProvider {
    @Injected(\.settingsProvider) var settingsProvider: SettingsProvider!
    @Injected(\.accountStorage) var accountStorage: AccountStorage!
    @Injected(\.logger) var logger: Logger!

    let session = Session()

    let reachabilityManager = NetworkReachabilityManager()
    let reachabilityObservers = Observers<NetworkReachabilityManager.NetworkReachabilityStatus>()
    private(set) lazy var authenticationInterceptor = AuthenticationInterceptor(
        authenticator: AuthenticatorImpl(tokenRefresher: self),
        credential: TokenCredential(nil)
    )
    var listenerTask: Task<Void, Never>?

    func startListenReachability() async {
        let stream = AsyncStream<NetworkReachabilityManager.NetworkReachabilityStatus> { [reachabilityManager] continuation in
            reachabilityManager?.startListening(onQueue: .global(qos: .userInitiated)) { status in
                continuation.yield(status)
            }
            continuation.onTermination = { @Sendable _ in
                reachabilityManager?.stopListening()
                continuation.finish()
            }
        }

        listenerTask = Task {
            for await status in stream {
                self.logger.info(
                    "NetworkStatus.Changed",
                    category: .network,
                    module: "NetworkProvider",
                    parameters: ["status": status]
                )
                await self.reachabilityObservers.notify(status)
            }
        }
    }

    func stopListenReachability() {
        listenerTask?.cancel()
    }

    func subscribe(
        _ callback: @Sendable @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) async -> Void
    ) async -> AnySendableObject {
        await reachabilityObservers.subscribe(callback, reachabilityManager?.status ?? .unknown)
    }

    func codable<T>(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> T where T: Sendable, T: Decodable {
        try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        ).serializingDecodable(T.self).value
    }

    func empty(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws {
        _ = try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        ).serializingDecodable(Empty.self).value
    }

    func string(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> String {
        try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        ).serializingString().value
    }

    func data(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> Data {
        try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        ).serializingData().value
    }

    func makeRequest(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async -> DataRequest {
        let url = settingsProvider.initialSettings.apiHost.appendingPathComponent(path)
        let interceptor = anonimous ? nil : authenticationInterceptor
        return session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.httpBody,
            headers: headers,
            interceptor: interceptor
        ).validate({ request, response, data in
            let statusCode = response.statusCode

            guard !(200..<300).contains(statusCode) else {
                return .success(())
            }

            if
                let data = data,
                let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            {
                return .failure(apiError)
            }

            return .failure(
                AFError.responseValidationFailed(
                    reason: .unacceptableStatusCode(code: statusCode)
                )
            )
        })
    }

}

extension NetworkProviderImpl: TokenRefresher {
    func refresh(token: String?) async throws -> Account? {
        self.logger.info(
            "AuthToken.Refresh.Start",
            category: .network,
            module: "NetworkProvider",
        )
        let account = await accountStorage.load()

        if let account, !account.isExpiredToken() && token != account.token {
            self.logger.debug("AuthToken.Refresh.End.WithLocalToken", category: .network, module: "NetworkProvider")
            return account
        }

        guard let token = account?.token ?? token else { return nil }

        let response: AuthResponse = try await codable(
            path: "/api/collections/users/auth-refresh",
            method: .post,
            parameters: nil,
            headers: [.authorization(token)],
            anonimous: true
        )
        guard let account = try response.convertToAccount(), !account.isExpiredToken() else {
            self.logger.debug("AuthToken.Refresh.Fail", category: .network, module: "NetworkProvider")
            return nil
        }
        self.logger.debug("AuthToken.Refresh.End.WithRemoteToken", category: .network, module: "NetworkProvider")
        await accountStorage.save(account: account)

        return account
    }
}
