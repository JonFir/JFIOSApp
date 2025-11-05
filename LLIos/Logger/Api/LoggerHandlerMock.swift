//
//  LoggerHandlerMock.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Foundation

/// Mock implementation of LoggerHandler for testing purposes.
///
/// This mock captures all log calls and stores them for verification in tests.
/// It provides access to call count and logged entries for assertions.
///
/// Example usage:
/// ```swift
/// let mock = LoggerHandlerMock()
/// let logger = Logger(handler: mock)
///
/// logger.info("Test message", category: .ui, module: "TestModule")
///
/// XCTAssertEqual(mock.logCallCount, 1)
/// XCTAssertEqual(mock.loggedEntries.first?.message, "Test message")
/// XCTAssertEqual(mock.loggedEntries.first?.level, .info)
/// ```
public final class LoggerHandlerMock: LoggerHandler {
    
    /// Represents a single logged entry with all its parameters.
    public struct LogEntry {
        public let level: LogLevel
        public let message: String
        public let parameters: [String: Any]
        public let category: LogCategory
        public let module: String
        public let file: String
        public let line: Int
        public let function: String
    }
    
    /// Number of times the log method was called.
    public private(set) var logCallCount: Int = 0
    
    /// All logged entries in the order they were received.
    public private(set) var loggedEntries: [LogEntry] = []
    
    /// Optional closure that gets called on each log invocation.
    public var onLog: ((LogLevel, String, [String: Any], LogCategory, String, String, Int, String) -> Void)?
    
    public init() {}
    
    public func log(
        level: LogLevel,
        message: String,
        parameters: [String: Any],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) {
        logCallCount += 1
        
        let entry = LogEntry(
            level: level,
            message: message,
            parameters: parameters,
            category: category,
            module: module,
            file: file,
            line: line,
            function: function
        )
        
        loggedEntries.append(entry)
        
        onLog?(level, message, parameters, category, module, file, line, function)
    }
    
    /// Resets the mock to its initial state.
    public func reset() {
        logCallCount = 0
        loggedEntries.removeAll()
        onLog = nil
    }
}

