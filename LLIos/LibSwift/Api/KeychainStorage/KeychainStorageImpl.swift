import Foundation
@preconcurrency import KeychainAccess

/// Implementation of KeychainStorage using KeychainAccess library.
///
/// KeychainStorageImpl provides secure storage of String and Codable values
/// using the system Keychain with the KeychainAccess wrapper library.
/// All Codable values are encoded to JSON before storage.
///
/// Example usage:
/// ```swift
/// // Create with default service identifier
/// let keychain = KeychainStorageImpl(service: "com.example.app")
///
/// // Create from existing Keychain instance
/// let customKeychain = Keychain(service: "com.example.app")
///     .accessibility(.afterFirstUnlock)
/// let storage = KeychainStorageImpl(keychain: customKeychain)
///
/// // Store and retrieve values
/// try storage.set("mySecretToken", forKey: "auth_token")
/// let token = try storage.getString(forKey: "auth_token")
/// ```
public final class KeychainStorageImpl: KeychainStorage {
    private let keychain: Keychain
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    /// Creates a KeychainStorage with a Keychain instance.
    ///
    /// - Parameter keychain: The Keychain instance to use for storage operations
    ///
    /// Example:
    /// ```swift
    /// let keychain = Keychain(service: "com.example.app")
    ///     .accessibility(.afterFirstUnlock)
    ///     .synchronizable(true)
    /// let storage = KeychainStorageImpl(keychain: keychain)
    /// ```
    public init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    /// Creates a KeychainStorage with a service identifier.
    ///
    /// - Parameter service: The service identifier for the keychain (e.g., bundle identifier)
    ///
    /// Example:
    /// ```swift
    /// let storage = KeychainStorageImpl(service: "com.example.app")
    /// ```
    public convenience init(service: String) {
        self.init(keychain: Keychain(service: service))
    }
    
    /// Creates a KeychainStorage with service identifier and access group.
    ///
    /// - Parameters:
    ///   - service: The service identifier for the keychain
    ///   - accessGroup: The access group for keychain sharing between apps
    ///
    /// Example:
    /// ```swift
    /// let storage = KeychainStorageImpl(
    ///     service: "com.example.app",
    ///     accessGroup: "com.example.group"
    /// )
    /// ```
    public convenience init(service: String, accessGroup: String) {
        self.init(keychain: Keychain(service: service, accessGroup: accessGroup))
    }
    
    public func set(_ value: String, forKey key: String) throws {
        try keychain.set(value, key: key)
    }
    
    public func getString(forKey key: String) throws -> String? {
        try keychain.getString(key)
    }
    
    public func setCodable<T: Codable & Sendable>(_ value: T, forKey key: String) throws {
        let data = try jsonEncoder.encode(value)
        try keychain.set(data, key: key)
    }
    
    public func getCodable<T: Codable & Sendable>(forKey key: String) throws -> T? {
        guard let data = try keychain.getData(key) else {
            return nil
        }
        return try jsonDecoder.decode(T.self, from: data)
    }
    
    public func remove(forKey key: String) throws {
        try keychain.remove(key)
    }
}
