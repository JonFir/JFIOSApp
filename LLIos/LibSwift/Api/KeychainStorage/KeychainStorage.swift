import Foundation
import FactoryKit

extension Container {
    public var keychainStorageWitService: ParameterFactory<String, KeychainStorage> {
        self {
            KeychainStorageImpl(service: $0)
        }.unique
    }
}


/// Protocol for secure storage of sensitive data in Keychain.
///
/// KeychainStorage provides a simple interface for storing and retrieving
/// both String and Codable values securely using the system Keychain.
/// All values are associated with unique keys for identification.
///
/// Example usage:
/// ```swift
/// let keychain: KeychainStorage = KeychainStorageImpl()
///
/// // Store and retrieve String values
/// try keychain.set("mySecretToken", forKey: "auth_token")
/// let token = try keychain.getString(forKey: "auth_token")
///
/// // Store and retrieve Codable values
/// struct User: Codable {
///     let id: String
///     let name: String
/// }
/// let user = User(id: "123", name: "John")
/// try keychain.set(user, forKey: "current_user")
/// let storedUser: User? = try keychain.getCodable(forKey: "current_user")
/// ```
public protocol KeychainStorage: Sendable {
    /// Stores a String value in the keychain.
    ///
    /// - Parameters:
    ///   - value: The String value to store
    ///   - key: The unique key to associate with the value
    /// - Throws: An error if the storage operation fails
    func set(_ value: String, forKey key: String) throws
    
    /// Retrieves a String value from the keychain.
    ///
    /// - Parameter key: The unique key associated with the value
    /// - Returns: The stored String value, or nil if no value exists for the key
    /// - Throws: An error if the retrieval operation fails
    func getString(forKey key: String) throws -> String?
    
    /// Stores a Codable value in the keychain.
    ///
    /// The value is encoded to JSON format before storage.
    ///
    /// - Parameters:
    ///   - value: The Codable value to store
    ///   - key: The unique key to associate with the value
    /// - Throws: An error if encoding or storage operation fails
    func setCodable<T: Codable & Sendable>(_ value: T, forKey key: String) throws
    
    /// Retrieves a Codable value from the keychain.
    ///
    /// The stored data is decoded from JSON format.
    ///
    /// - Parameter key: The unique key associated with the value
    /// - Returns: The decoded value, or nil if no value exists for the key
    /// - Throws: An error if the retrieval or decoding operation fails
    func getCodable<T: Codable & Sendable>(forKey key: String) throws -> T?
    
    /// Removes a value from the keychain.
    ///
    /// - Parameter key: The unique key associated with the value to remove
    /// - Throws: An error if the removal operation fails
    func remove(forKey key: String) throws
}

