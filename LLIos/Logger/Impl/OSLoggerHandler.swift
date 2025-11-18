//
//  OSLoggerHandler.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Foundation
import OSLog
import Logger

/// Logger handler implementation that writes logs to the system's unified logging system (os_log).
///
/// This handler uses OSLog to integrate with Apple's unified logging system,
/// which allows viewing logs through Console.app and using log streaming commands.
/// Logs are organized by subsystem and category for better filtering and analysis.
///
/// Example usage:
/// ```swift
/// let logger = Logger()
/// logger.handlers = [OSLoggerHandler(subsystem: "com.example.app")]
///
/// logger.info("User logged in", category: .domain, module: "UserModule", parameters: ["userId": 123])
/// ```
final class OSLoggerHandler: LoggerHandler {
    
    private let osLog: OSLog
    
    /// Creates a new OSLoggerHandler with the specified subsystem.
    ///
    /// The subsystem is typically the bundle identifier of your app or framework.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem identifier for organizing logs
    ///   - category: The category name for the unified logger (default: "Logger")
    ///
    /// Example usage:
    /// ```swift
    /// let handler = OSLoggerHandler(subsystem: "com.example.myapp")
    /// ```
    init(subsystem: String, category: String) {
        self.osLog = OSLog(subsystem: subsystem, category: category)
    }
    
    func log(
        level: LogLevel,
        message: String,
        parameters: [String: Sendable],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) {
        let osLogType = mapLogLevel(level)
        let formattedMessage = formatLogMessage(
            level: level,
            message: message,
            parameters: parameters,
            category: category,
            module: module,
            file: file,
            line: line,
            function: function
        )
        
        os_log("%{public}@", log: osLog, type: osLogType, formattedMessage)
    }
    
    private func mapLogLevel(_ level: LogLevel) -> OSLogType {
        switch level {
        case .critical:
            return .fault
        case .warning:
            return .error
        case .info:
            return .info
        case .debug:
            return .debug
        }
    }
}
