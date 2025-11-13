import Foundation
import FactoryKit

extension Container {
    public var logger: Factory<Logger?> { promised().singleton }
}

/// Main logging class that distributes log messages to registered handlers.
///
/// Logger provides methods for each log level and manages a collection of handlers
/// that process the log events. All log methods automatically capture file, line,
/// and function information for better debugging.
///
/// Example usage:
/// ```swift
/// let logger = Logger()
/// logger.handlers = [ConsoleLoggerHandler(), FileLoggerHandler()]
///
/// logger.info("User logged in", category: .domain, module: "UserModule", parameters: ["userId": 123])
/// logger.warning("API response slow", category: .network, module: "APIClient", parameters: ["duration": 2.5])
/// logger.critical("Database connection failed", category: .domain, module: "CoreData", parameters: ["error": error])
/// ```
public final class Logger {
    
    /// Array of handlers that will process log events.
    ///
    /// Set this property to configure which handlers should receive log messages.
    /// Multiple handlers can be used simultaneously to output logs to different destinations.
    ///
    /// Example usage:
    /// ```swift
    /// logger.handlers = [ConsoleLoggerHandler(), RemoteLoggerHandler()]
    /// ```
    public var handlers: [LoggerHandler] = []
    
    public init() {}
    
    /// Logs a critical error message.
    ///
    /// Use this method for critical errors that require immediate attention,
    /// such as data corruption, security issues, or unrecoverable failures.
    ///
    /// - Parameters:
    ///   - message: The log message describing the critical error
    ///   - category: The category of the log
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.critical("Database connection lost", category: .domain, module: "CoreData", parameters: ["error": error.localizedDescription])
    /// ```
    public func critical(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Any] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(level: .critical, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }
    
    /// Logs a warning message.
    ///
    /// Use this method for potentially harmful situations that don't prevent
    /// the application from functioning but should be investigated.
    ///
    /// - Parameters:
    ///   - message: The log message describing the warning
    ///   - category: The category of the log
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.warning("API response took longer than expected", category: .network, module: "APIClient", parameters: ["duration": 3.2])
    /// ```
    public func warning(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Any] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(level: .warning, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }
    
    /// Logs an informational message.
    ///
    /// Use this method for general informational messages that highlight
    /// the progress or state of the application.
    ///
    /// - Parameters:
    ///   - message: The log message describing the information
    ///   - category: The category of the log
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.info("User successfully logged in", category: .domain, module: "UserModule", parameters: ["userId": 123, "username": "john"])
    /// ```
    public func info(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Any] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(level: .info, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }
    
    /// Logs a debug message.
    ///
    /// Use this method for detailed information typically useful only
    /// during development and debugging.
    ///
    /// - Parameters:
    ///   - message: The log message describing the debug information
    ///   - category: The category of the log
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.debug("Cache hit", category: .domain, module: "DataLayer", parameters: ["key": "user_profile", "size": 1024])
    /// ```
    public func debug(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Any] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(level: .debug, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }
    
    private func log(
        level: LogLevel,
        message: String,
        parameters: [String: Any],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) {
        handlers.forEach { handler in
            handler.log(
                level: level,
                message: message,
                parameters: parameters,
                category: category,
                module: module,
                file: file,
                line: line,
                function: function
            )
        }
    }
}

