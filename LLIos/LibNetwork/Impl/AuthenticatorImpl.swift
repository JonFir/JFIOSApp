import Alamofire
import Foundation
import AccountStorage
import FactoryKit
import LibSwift
import LibNetwork

struct TokenCredential: AuthenticationCredential {
    let account: Account?

    init(_ account: Account?) {
        self.account = account
    }

    var requiresRefresh: Bool {
        guard let account else { return false }

        return account.isExpiredToken()
    }
}

protocol TokenRefresher: AnyObject, Sendable {
    func refresh(token: String?) async throws -> Account?
}

final class AuthenticatorImpl: Authenticator {
    nonisolated(unsafe) private(set) weak var tokenRefresher: TokenRefresher?

    init(tokenRefresher: TokenRefresher?) {
        self.tokenRefresher = tokenRefresher
    }

    func apply(
        _ credential: TokenCredential,
        to urlRequest: inout URLRequest
    ) {
        if let accessToken = credential.account?.token {
            urlRequest.headers.add(.authorization(accessToken))
        }
    }
    
    func refresh(
        _ credential: TokenCredential,
        for session: Alamofire.Session,
        completion: @escaping @Sendable (Result<TokenCredential, any Error>) -> Void
    ) {
        Task {
            do {
                let token =  try await tokenRefresher?.refresh(token: credential.account?.token)

                if let token {
                    completion(.success(TokenCredential(token)))
                } else {
                    throw APIErrorResponse(status: 401, message: "Missing auth credentials")
                }
            } catch {
                completion(.failure(error))
            }

        }
    }
    
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: any Error
    ) -> Bool {
        response.statusCode == 404
    }
    
    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: TokenCredential
    ) -> Bool {
        urlRequest.headers["Authorization"] == credential.account?.token
    }

}
