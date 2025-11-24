import Testing
@testable import LibSwift
import Foundation

@Suite("KeychainStorage Tests")
actor KeychainStorageTests {
    let storage: KeychainStorageMock
    
    init() {
        storage = KeychainStorageMock()
    }
    
    @Test("Set and get string value")
    func setAndGetString() throws {
        try storage.set("testValue", forKey: "testKey")
        
        let result = try storage.getString(forKey: "testKey")
        
        #expect(result == "testValue")
    }
    
    @Test("Get non-existent string returns nil")
    func getNonExistentStringReturnsNil() throws {
        let result = try storage.getString(forKey: "nonExistentKey")
        
        #expect(result == nil)
    }
    
    @Test("Overwrite existing string value")
    func overwriteExistingStringValue() throws {
        try storage.set("firstValue", forKey: "testKey")
        try storage.set("secondValue", forKey: "testKey")
        
        let result = try storage.getString(forKey: "testKey")
        
        #expect(result == "secondValue")
    }
    
    @Test("Set and get Codable value")
    func setAndGetCodable() throws {
        struct TestData: Codable, Equatable, Sendable {
            let name: String
            let age: Int
        }
        
        let testData = TestData(name: "John", age: 30)
        try storage.set(testData, forKey: "userData")
        
        let result: TestData? = try storage.getCodable(forKey: "userData")
        
        #expect(result == testData)
    }
    
    @Test("Get non-existent Codable returns nil")
    func getNonExistentCodableReturnsNil() throws {
        struct TestData: Codable, Sendable {
            let name: String
        }
        
        let result: TestData? = try storage.getCodable(forKey: "nonExistentKey")
        
        #expect(result == nil)
    }
    
    @Test("Overwrite existing Codable value")
    func overwriteExistingCodableValue() throws {
        struct TestData: Codable, Equatable, Sendable {
            let value: String
        }
        
        try storage.set(TestData(value: "first"), forKey: "testKey")
        try storage.set(TestData(value: "second"), forKey: "testKey")
        
        let result: TestData? = try storage.getCodable(forKey: "testKey")
        
        #expect(result?.value == "second")
    }
    
    @Test("Remove string value")
    func removeStringValue() throws {
        try storage.set("testValue", forKey: "testKey")
        try storage.remove(forKey: "testKey")
        
        let result = try storage.getString(forKey: "testKey")
        
        #expect(result == nil)
    }
    
    @Test("Remove Codable value")
    func removeCodableValue() throws {
        struct TestData: Codable, Sendable {
            let name: String
        }
        
        try storage.set(TestData(name: "test"), forKey: "testKey")
        try storage.remove(forKey: "testKey")
        
        let result: TestData? = try storage.getCodable(forKey: "testKey")
        
        #expect(result == nil)
    }
    
    @Test("Remove non-existent key")
    func removeNonExistentKey() throws {
        try storage.remove(forKey: "nonExistentKey")
        
        let result = try storage.getString(forKey: "nonExistentKey")
        
        #expect(result == nil)
    }
    
    @Test("Multiple keys isolation")
    func multipleKeysIsolation() throws {
        try storage.set("value1", forKey: "key1")
        try storage.set("value2", forKey: "key2")
        try storage.set("value3", forKey: "key3")
        
        let result1 = try storage.getString(forKey: "key1")
        let result2 = try storage.getString(forKey: "key2")
        let result3 = try storage.getString(forKey: "key3")
        
        #expect(result1 == "value1")
        #expect(result2 == "value2")
        #expect(result3 == "value3")
    }
    
    @Test("Complex Codable value")
    func complexCodableValue() throws {
        struct ComplexData: Codable, Equatable, Sendable {
            let string: String
            let number: Int
            let double: Double
            let array: [String]
            let dict: [String: Int]
            let nested: NestedData
        }
        
        struct NestedData: Codable, Equatable, Sendable {
            let value: String
        }
        
        let testData = ComplexData(
            string: "test",
            number: 42,
            double: 3.14,
            array: ["a", "b", "c"],
            dict: ["one": 1, "two": 2],
            nested: NestedData(value: "nested")
        )
        
        try storage.set(testData, forKey: "complexData")
        
        let result: ComplexData? = try storage.getCodable(forKey: "complexData")
        
        #expect(result == testData)
    }
    
    @Test("String with special characters")
    func stringWithSpecialCharacters() throws {
        let specialString = "Test 🔐 with émojis and spëcial châracters! @#$%^&*()"
        
        try storage.set(specialString, forKey: "specialKey")
        
        let result = try storage.getString(forKey: "specialKey")
        
        #expect(result == specialString)
    }
    
    @Test("Empty string value")
    func emptyStringValue() throws {
        try storage.set("", forKey: "emptyKey")
        
        let result = try storage.getString(forKey: "emptyKey")
        
        #expect(result == "")
    }
    
    @Test("Mix String and Codable in different keys")
    func mixStringAndCodable() throws {
        struct TestData: Codable, Equatable, Sendable {
            let value: String
        }
        
        try storage.set("stringValue", forKey: "stringKey")
        try storage.set(TestData(value: "codableValue"), forKey: "codableKey")
        
        let stringResult = try storage.getString(forKey: "stringKey")
        let codableResult: TestData? = try storage.getCodable(forKey: "codableKey")
        
        #expect(stringResult == "stringValue")
        #expect(codableResult?.value == "codableValue")
    }
}

