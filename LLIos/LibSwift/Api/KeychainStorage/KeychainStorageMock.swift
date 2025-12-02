import Foundation

/// Mock implementation of KeychainStorage for testing purposes.
///
/// KeychainStorageMock provides an in-memory implementation of KeychainStorage
/// that doesn't interact with the actual system Keychain. This is useful for
/// unit testing and preview environments.
///
/// Example usage:
/// ```swift
/// let mock = KeychainStorageMock()
///
/// // Preload mock data
/// mock.storage["auth_token"] = Data("mockToken".utf8)
///
/// // Use in tests
/// let token = try mock.getString(forKey: "auth_token")
/// XCTAssertEqual(token, "mockToken")
/// ```
public final class KeychainStorageMock: KeychainStorage, @unchecked Sendable {
    public var storage: [String: Data] = [:]
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    public init() {}
    
    public func set(_ value: String, forKey key: String) throws {
        storage[key] = Data(value.utf8)
    }
    
    public func getString(forKey key: String) throws -> String? {
        guard let data = storage[key] else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    public func setCodable<T: Codable & Sendable>(_ value: T, forKey key: String) throws {
        let data = try jsonEncoder.encode(value)
        storage[key] = data
    }
    
    public func getCodable<T: Codable & Sendable>(forKey key: String) throws -> T? {
        guard let data = storage[key] else {
            return nil
        }
        return try jsonDecoder.decode(T.self, from: data)
    }
    
    public func remove(forKey key: String) throws {
        storage.removeValue(forKey: key)
    }
}
