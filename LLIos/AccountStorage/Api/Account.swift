import Foundation

/// Represents a user account with authentication and profile information.
///
/// Example usage:
/// ```swift
/// let account = Account(
///     id: "user123",
///     email: "user@example.com",
///     name: "John Doe",
///     token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
///     expiration: 1718534400
/// )
/// ```
public struct Account: Codable, Sendable, Equatable {
    /// Server-provided unique identifier for the account.
    public let id: String
    public let email: String?
    public let name: String?
    /// Server-provided JWT authentication token.
    public let token: String
    /// Expiration time for the token.
    public let expiration: TimeInterval

    public init(
        id: String,
        email: String?,
        name: String?,
        token: String,
        expiration: TimeInterval,
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.token = token
        self.expiration = expiration
    }

    public func isExpiredToken() -> Bool {
        let twoDays: Double = 172800
        let isExpired = Date.now.timeIntervalSince1970 >= expiration - twoDays
        return isExpired
    }
}
