import Testing
@testable import LibSwift
import Logger
import FactoryKit
import Foundation

@Suite("FilePersistence Tests")
actor FilePersistenceTests {
    let testDirectory: URL
    
    init() {
        testDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        Container.shared.logger.register {
            Logger(handlers: [])
        }
    }
    
    deinit {
        try? FileManager.default.removeItem(at: testDirectory)
        Container.shared.manager.reset()
    }
    
    @Test("Write and read value")
    func writeAndReadValue() {
        struct TestData: Codable, Equatable {
            let name: String
            let age: Int
        }
        
        @FilePersistence(
            filename: "test.plist",
            directoryURL: testDirectory,
            defaultValue: TestData(name: "Default", age: 0)
        )
        var data: TestData
        
        let expectedValue = TestData(name: "John", age: 30)
        data = expectedValue

        @FilePersistence(
            filename: "test.plist",
            directoryURL: testDirectory,
            defaultValue: TestData(name: "Default", age: 0)
        )
        var newData: TestData
        
        #expect(newData == expectedValue)
    }
    
    @Test("Default value when file does not exist")
    func defaultValueWhenFileDoesNotExist() {
        @FilePersistence(
            filename: "nonexistent.plist",
            directoryURL: testDirectory,
            defaultValue: "DefaultValue"
        )
        var value: String
        
        #expect(value == "DefaultValue")
    }
    
    @Test("Default value on read error")
    func defaultValueOnReadError() {
        let corruptedFile = testDirectory.appendingPathComponent("corrupted.plist")
        try? "This is not a valid plist".write(to: corruptedFile, atomically: true, encoding: .utf8)
        
        @FilePersistence(
            filename: "corrupted.plist",
            directoryURL: testDirectory,
            defaultValue: "DefaultValue"
        )
        var value: String
        
        #expect(value == "DefaultValue")
    }
    
    @Test("Overwrite existing value")
    func overwriteExistingValue() {
        @FilePersistence(
            filename: "test.plist",
            directoryURL: testDirectory,
            defaultValue: "Default"
        )
        var value: String
        
        value = "FirstValue"
        value = "SecondValue"
        
        @FilePersistence(
            filename: "test.plist",
            directoryURL: testDirectory,
            defaultValue: "Default"
        )
        var newValue: String
        
        #expect(newValue == "SecondValue")
    }
    
    @Test("Cached value is used")
    func cachedValueIsUsed() {
        @FilePersistence(
            filename: "cached.plist",
            directoryURL: testDirectory,
            defaultValue: 0
        )
        var value: Int
        
        value = 42
        
        let firstRead = value
        
        let fileURL = testDirectory.appendingPathComponent("cached.plist")
        try? FileManager.default.removeItem(at: fileURL)
        
        let secondRead = value
        
        #expect(firstRead == 42)
        #expect(secondRead == 42)
    }
    
    @Test("Directory creation on write")
    func directoryCreationOnWrite() {
        let nestedDirectory = testDirectory
            .appendingPathComponent("nested")
            .appendingPathComponent("deep")
        
        @FilePersistence(
            filename: "test.plist",
            directoryURL: nestedDirectory,
            defaultValue: "TestValue"
        )
        var value: String
        
        value = "NewValue"
        
        #expect(FileManager.default.fileExists(atPath: nestedDirectory.path))
        
        let fileURL = nestedDirectory.appendingPathComponent("test.plist")
        #expect(FileManager.default.fileExists(atPath: fileURL.path))
    }
    
    @Test("PropertyList format")
    func propertyListFormat() throws {
        struct ComplexData: Codable, Equatable {
            let string: String
            let number: Int
            let double: Double
            let array: [String]
            let dict: [String: Int]
        }
        
        let testData = ComplexData(
            string: "test",
            number: 42,
            double: 3.14,
            array: ["a", "b", "c"],
            dict: ["one": 1, "two": 2]
        )
        
        @FilePersistence(
            filename: "complex.plist",
            directoryURL: testDirectory,
            defaultValue: testData
        )
        var data: ComplexData
        
        data = testData
        
        let fileURL = testDirectory.appendingPathComponent("complex.plist")
        let fileData = try Data(contentsOf: fileURL)
        
        #expect(fileData.count > 0)
        #expect(fileData.starts(with: [0x62, 0x70, 0x6C, 0x69, 0x73, 0x74]))
    }
    
    @Test("Multiple files in same directory")
    func multipleFilesInSameDirectory() {
        @FilePersistence(
            filename: "file1.plist",
            directoryURL: testDirectory,
            defaultValue: "value1"
        )
        var value1: String
        
        @FilePersistence(
            filename: "file2.plist",
            directoryURL: testDirectory,
            defaultValue: "value2"
        )
        var value2: String
        
        value1 = "updated1"
        value2 = "updated2"
        
        @FilePersistence(
            filename: "file1.plist",
            directoryURL: testDirectory,
            defaultValue: "value1"
        )
        var newValue1: String
        
        @FilePersistence(
            filename: "file2.plist",
            directoryURL: testDirectory,
            defaultValue: "value2"
        )
        var newValue2: String
        
        #expect(newValue1 == "updated1")
        #expect(newValue2 == "updated2")
    }
}

