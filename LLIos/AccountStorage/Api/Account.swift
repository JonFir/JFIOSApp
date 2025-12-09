import Foundation

/// Represents a user account with authentication and profile information.
///
/// Example usage:
/// ```swift
/// let account = Account(
///     id: "user123",
///     email: "user@example.com",
///     name: "John Doe",
///     token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
/// )
/// ```
public struct Account: Codable, Sendable, Equatable {
    /// Server-provided unique identifier for the account.
    public let id: String
    public let email: String?
    public let name: String?
    /// Server-provided JWT authentication token.
    public let token: String

    public init(
        id: String,
        email: String?,
        name: String?,
        token: String
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.token = token
    }
}
