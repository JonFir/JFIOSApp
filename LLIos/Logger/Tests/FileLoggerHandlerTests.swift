import Testing
import Foundation
@testable import Logger
@testable import LoggerImpl

struct FileLoggerHandlerTests {
    
    @Test
    func writesLogToFile() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "Test message",
            parameters: [:],
            category: .domain,
            module: "TestModule",
            file: "TestFile.swift",
            line: 42,
            function: "testFunction()"
        )
        
        let todayLogs = try handler.getTodayLogs()
        let logsString = String(data: todayLogs, encoding: .utf8)
        
        #expect(logsString?.contains("Test message") == true)
        #expect(logsString?.contains("INFO") == true)
        #expect(logsString?.contains("TestModule") == true)
        
        try handler.clearLogs()
    }
    
    @Test
    func writesMultipleLogsToFile() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "First message",
            parameters: [:],
            category: .domain,
            module: "Module1",
            file: "File1.swift",
            line: 10,
            function: "func1()"
        )
        
        await handler.log(
            level: .warning,
            message: "Second message",
            parameters: [:],
            category: .network,
            module: "Module2",
            file: "File2.swift",
            line: 20,
            function: "func2()"
        )
        
        let todayLogs = try handler.getTodayLogs()
        let logsString = String(data: todayLogs, encoding: .utf8)
        
        #expect(logsString?.contains("First message") == true)
        #expect(logsString?.contains("Second message") == true)
        #expect(logsString?.contains("INFO") == true)
        #expect(logsString?.contains("WARNING") == true)
        
        try handler.clearLogs()
    }
    
    @Test
    func getAllLogsReturnsAllFiles() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "Log entry",
            parameters: [:],
            category: .domain,
            module: "TestModule",
            file: "TestFile.swift",
            line: 1,
            function: "test()"
        )
        
        let allLogs = try handler.getAllLogs()
        let logsString = String(data: allLogs, encoding: .utf8)
        
        #expect(logsString?.contains("Log entry") == true)
        #expect(allLogs.count > 0)
        
        try handler.clearLogs()
    }
    
    @Test
    func getTodayLogsReturnsOnlyTodayLogs() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "Today's log",
            parameters: [:],
            category: .domain,
            module: "TestModule",
            file: "TestFile.swift",
            line: 1,
            function: "test()"
        )
        
        let todayLogs = try handler.getTodayLogs()
        let logsString = String(data: todayLogs, encoding: .utf8)
        
        #expect(logsString?.contains("Today's log") == true)
        
        try handler.clearLogs()
    }
    
    @Test
    func clearLogsRemovesAllFiles() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "Log to be cleared",
            parameters: [:],
            category: .domain,
            module: "TestModule",
            file: "TestFile.swift",
            line: 1,
            function: "test()"
        )
        
        let logsBeforeClear = try handler.getTodayLogs()
        #expect(logsBeforeClear.count > 0)
        
        try handler.clearLogs()
        
        let logsAfterClear = try handler.getTodayLogs()
        #expect(logsAfterClear.count == 0)
    }
    
    @Test
    func logsIncludeParameters() async throws {
        let handler = try #require(FileLoggerHandler())
        
        let parameters: [String: any Sendable] = ["userId": 123, "action": "login"]
        
        await handler.log(
            level: .info,
            message: "User action",
            parameters: parameters,
            category: .domain,
            module: "UserModule",
            file: "User.swift",
            line: 50,
            function: "performAction()"
        )
        
        let todayLogs = try handler.getTodayLogs()
        let logsString = String(data: todayLogs, encoding: .utf8)
        
        #expect(logsString?.contains("userId") == true)
        #expect(logsString?.contains("123") == true)
        #expect(logsString?.contains("action") == true)
        #expect(logsString?.contains("login") == true)
        
        try handler.clearLogs()
    }
    
    @Test
    func logsIncludeAllLogLevels() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .debug,
            message: "Debug message",
            parameters: [:],
            category: .domain,
            module: "Module",
            file: "File.swift",
            line: 1,
            function: "test()"
        )
        
        await handler.log(
            level: .info,
            message: "Info message",
            parameters: [:],
            category: .domain,
            module: "Module",
            file: "File.swift",
            line: 2,
            function: "test()"
        )
        
        await handler.log(
            level: .warning,
            message: "Warning message",
            parameters: [:],
            category: .domain,
            module: "Module",
            file: "File.swift",
            line: 3,
            function: "test()"
        )
        
        await handler.log(
            level: .critical,
            message: "Critical message",
            parameters: [:],
            category: .domain,
            module: "Module",
            file: "File.swift",
            line: 4,
            function: "test()"
        )
        
        let todayLogs = try handler.getTodayLogs()
        let logsString = String(data: todayLogs, encoding: .utf8)
        
        #expect(logsString?.contains("DEBUG") == true)
        #expect(logsString?.contains("INFO") == true)
        #expect(logsString?.contains("WARNING") == true)
        #expect(logsString?.contains("CRITICAL") == true)
        
        try handler.clearLogs()
    }
    
    @Test
    func performLogRotationRemovesOldFiles() async throws {
        let handler = try #require(FileLoggerHandler())
        let fileManager = FileManager.default
        
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            Issue.record("Unable to access caches directory")
            return
        }
        
        let logsDirectory = cachesDirectory.appendingPathComponent("Logs", isDirectory: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let oldDate = Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? Date()
        let oldFileName = "log-\(dateFormatter.string(from: oldDate)).txt"
        let oldFileURL = logsDirectory.appendingPathComponent(oldFileName)
        
        try "Old log content".write(to: oldFileURL, atomically: true, encoding: .utf8)
        
        #expect(fileManager.fileExists(atPath: oldFileURL.path))
        
        try handler.performLogRotation()
        
        #expect(!fileManager.fileExists(atPath: oldFileURL.path))
        
        try handler.clearLogs()
    }
    
    @Test
    func performLogRotationKeepsRecentFiles() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "Recent log",
            parameters: [:],
            category: .domain,
            module: "Module",
            file: "File.swift",
            line: 1,
            function: "test()"
        )
        
        let logsBeforeRotation = try handler.getTodayLogs()
        #expect(logsBeforeRotation.count > 0)
        
        try handler.performLogRotation()
        
        let logsAfterRotation = try handler.getTodayLogs()
        #expect(logsAfterRotation.count > 0)
        
        try handler.clearLogs()
    }
    
    @Test
    func emptyLogsReturnEmptyData() throws {
        let handler = try #require(FileLoggerHandler())
        
        let todayLogs = try handler.getTodayLogs()
        #expect(todayLogs.count == 0)
        
        let allLogs = try handler.getAllLogs()
        #expect(allLogs.count == 0)
    }
    
    @Test
    func logsIncludeTimestamp() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "Timestamped message",
            parameters: [:],
            category: .domain,
            module: "Module",
            file: "File.swift",
            line: 1,
            function: "test()"
        )
        
        let todayLogs = try handler.getTodayLogs()
        let logsString = String(data: todayLogs, encoding: .utf8)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        #expect(logsString?.contains(String(currentYear)) == true)
        
        try handler.clearLogs()
    }
    
    @Test
    func logsIncludeLocationInfo() async throws {
        let handler = try #require(FileLoggerHandler())
        
        await handler.log(
            level: .info,
            message: "Location test",
            parameters: [:],
            category: .domain,
            module: "TestModule",
            file: "TestFile.swift",
            line: 123,
            function: "testFunction()"
        )
        
        let todayLogs = try handler.getTodayLogs()
        let logsString = String(data: todayLogs, encoding: .utf8)
        
        #expect(logsString?.contains("TestFile.swift") == true)
        #expect(logsString?.contains("123") == true)
        #expect(logsString?.contains("testFunction()") == true)
        
        try handler.clearLogs()
    }
}
