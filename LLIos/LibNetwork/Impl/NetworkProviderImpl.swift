import Alamofire
import LibSwift
import LibNetwork
import Foundation
import FactoryKit
import Settings

actor NetworkProviderImpl: NetworkProvider {
    @Injected(\.settingsProvider) var settingsProvider: SettingsProvider!

    let session = Session()

    let reachabilityManager = NetworkReachabilityManager()
    let reachabilityObservers = Observers<NetworkReachabilityManager.NetworkReachabilityStatus>()
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
    ) async throws -> T where T: Sendable, T: Decodable {
        try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers
        ).serializingDecodable(T.self).value
    }

    func empty(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
    ) async throws {
        _ = try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers
        ).serializingDecodable(Empty.self).value
    }

    func string(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
    ) async throws -> String {
        try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers
        ).serializingString().value
    }

    func data(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
    ) async throws -> Data {
        try await makeRequest(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers
        ).serializingData().value
    }

    func makeRequest(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
    ) -> DataRequest {
        let url = settingsProvider.initialSettings.apiHost.appendingPathComponent(path)
        return session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.httpBody,
            headers: headers
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
