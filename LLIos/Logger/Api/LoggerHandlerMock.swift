//
//  LoggerHandlerMock.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Foundation

/// Mock implementation of LoggerHandler for testing purposes.
///
/// This mock is implemented as an actor and captures all log calls for verification in tests.
/// It provides access to call count and logged entries through isolated properties that require await.
/// All interactions with the mock should be done asynchronously.
///
/// Example usage:
/// ```swift
/// let mock = LoggerHandlerMock()
/// let logger = Logger(handlers: [mock])
///
/// logger.info("Test message", category: .ui, module: "TestModule")
/// try? await Task.sleep(for: .milliseconds(10))
///
/// let callCount = await mock.logCallCount
/// let entries = await mock.loggedEntries
/// #expect(callCount == 1)
/// #expect(entries.first?.message == "Test message")
/// #expect(entries.first?.level == .info)
/// ```
public actor LoggerHandlerMock: LoggerHandler {

    /// Represents a single logged entry with all its parameters.
    public struct LogEntry: Sendable {
        public let level: LogLevel
        public let message: String
        public let parameters: [String: Sendable]
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
    private var onLog: ((LogLevel, String, [String: Any], LogCategory, String, String, Int, String) -> Void)?
    
    public init() {}
    
    /// Sets the closure that will be called on each log invocation.
    ///
    /// - Parameter closure: The closure to be called when log method is invoked
    public func setOnLog(_ closure: (@Sendable (LogLevel, String, [String: Sendable], LogCategory, String, String, Int, String) -> Void)?) {
        onLog = closure
    }
    
    public func log(
        level: LogLevel,
        message: String,
        parameters: [String: Sendable],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) async {
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
        setOnLog(nil)
    }
}
