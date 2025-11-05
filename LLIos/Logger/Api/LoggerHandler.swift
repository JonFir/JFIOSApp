//
//  LoggerHandler.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Foundation

/// Protocol for handling log events.
///
/// Implement this protocol to create custom log handlers that can process
/// log messages in different ways (console output, file writing, remote logging, etc.).
///
/// Example usage:
/// ```swift
/// class ConsoleLoggerHandler: LoggerHandler {
///     func log(level: LogLevel, message: String, parameters: [String: Any], category: LogCategory, module: String, file: String, line: Int, function: String) {
///         print("[\(level)][\(module)][\(category.rawValue)] \(message) at \(file):\(line)")
///     }
/// }
/// ```
public protocol LoggerHandler {
    /// Handles a log event.
    ///
    /// - Parameters:
    ///   - level: The severity level of the log message
    ///   - message: The log message text
    ///   - parameters: Additional parameters associated with the log event
    ///   - category: The category of the log
    ///   - module: The module name where the log originated
    ///   - file: The file where the log was called
    ///   - line: The line number where the log was called
    ///   - function: The function where the log was called
    func log(
        level: LogLevel,
        message: String,
        parameters: [String: Any],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    )
}

