import Foundation
import FactoryKit
import LibSwift

extension Container {
    public var accountStorage: Factory<AccountStorage?> { promised().singleton }
}

/// Provides secure storage and retrieval of user account information.
///
/// AccountStorage is an actor that manages account data persistence in Keychain,
/// storing the entire Account structure including the token securely.
/// It supports multiple subscribers for account changes and ensures thread-safe
/// access to account data.
///
/// Example usage:
/// ```swift
/// let storage = Container.shared.accountStorage()
///
/// let account = Account(id: "123", email: "user@example.com", name: "John", token: "secret")
/// await storage.save(account: account)
///
/// if let loaded = await storage.load() {
///     print("Loaded account: \(loaded.email)")
/// }
///
/// await storage.subscribe { account in
///     print("Account changed: \(account?.email ?? "nil")")
/// }
///
/// await storage.delete()
/// ```
public protocol AccountStorage: Actor {
    /// Saves account information securely to Keychain.
    ///
    /// The entire Account structure (including token) is serialized to Data
    /// and stored in Keychain. All subscribers are notified after successful save.
    ///
    /// - Parameter account: The account to save
    ///
    /// Example usage:
    /// ```swift
    /// let account = Account(id: "123", email: "user@example.com", name: "John", token: "token")
    /// await storage.save(account: account)
    /// ```
    func save(account: Account) async

    /// Loads the currently stored account if it exists.
    ///
    /// Reads and deserializes the Account from Keychain.
    /// Returns nil if no account is stored or if data cannot be deserialized.
    ///
    /// - Returns: The stored account, or nil if no account exists
    ///
    /// Example usage:
    /// ```swift
    /// if let account = await storage.load() {
    ///     print("Found account: \(account.email)")
    /// } else {
    ///     print("No account stored")
    /// }
    /// ```
    func load() async -> Account?

    /// Deletes all stored account information from Keychain.
    ///
    /// Removes the account data from Keychain.
    /// All subscribers are notified with nil after successful deletion.
    ///
    /// Example usage:
    /// ```swift
    /// await storage.delete()
    /// ```
    func delete() async
    
    /// Subscribes to account changes with automatic cleanup when token is deallocated.
    ///
    /// Multiple subscribers are supported. Callbacks are invoked whenever the account
    /// is saved, deleted, or modified. The callback receives the current account
    /// immediately upon subscription. Keep the returned token alive as long as you
    /// want to receive updates.
    ///
    /// - Parameter callback: Closure called when account is updated or deleted
    /// - Returns: Subscription token that must be retained to keep subscription active
    ///
    /// Example usage:
    /// ```swift
    /// let token = await storage.subscribe { account in
    ///     if let account = account {
    ///         print("Account updated: \(account.email)")
    ///     } else {
    ///         print("Account deleted")
    ///     }
    /// }
    /// ```
    func subscribe(_ callback: @escaping @Sendable (Account?) async -> Void) async -> AnySendableObject
}
