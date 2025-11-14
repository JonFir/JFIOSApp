import Foundation
import FactoryKit

extension Container {
    public var logger: Factory<Logger?> { promised().singleton }
}

/// Main logging actor that distributes log messages to registered handlers.
///
/// Logger is implemented as an actor to ensure thread-safe access to handlers.
/// All public logging methods are nonisolated for convenient usage from any context,
/// while the actual logging happens asynchronously. Each log method requires a category
/// and module name for better organization and filtering. All methods automatically
/// capture file, line, and function information for debugging.
///
/// Example usage:
/// ```swift
/// let logger = Logger(handlers: [OSLoggerHandler(), FileLoggerHandler()])
///
/// logger.info("User logged in", category: .domain, module: "UserModule", parameters: ["userId": 123])
/// logger.warning("API response slow", category: .network, module: "APIClient", parameters: ["duration": 2.5])
/// logger.critical("Database connection failed", category: .domain, module: "CoreData", parameters: ["error": error])
/// ```
public actor Logger {
    let handlers: [LoggerHandler]
    
    /// Creates a new Logger instance with the specified handlers.
    ///
    /// - Parameter handlers: Array of handlers that will process log events
    ///
    /// Example usage:
    /// ```swift
    /// let logger = Logger(handlers: [OSLoggerHandler(), FileLoggerHandler()])
    /// ```
    public init(handlers: [LoggerHandler]) {
        self.handlers = handlers
    }

    /// Logs a critical error message.
    ///
    /// This method is nonisolated and can be called from any context without await.
    /// The actual logging is dispatched asynchronously to all registered handlers.
    /// Use this method for critical errors that require immediate attention,
    /// such as data corruption, security issues, or unrecoverable failures.
    ///
    /// - Parameters:
    ///   - message: The log message describing the critical error
    ///   - category: The category of the log event for filtering and organization
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters as Sendable values (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.critical("Database connection lost", category: .domain, module: "CoreData", parameters: ["error": error.localizedDescription])
    /// ```
    @discardableResult
    public nonisolated func critical(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Sendable] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) -> Task<Void, Never> {
        logSync(level: .critical, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }
    
    /// Logs a warning message.
    ///
    /// This method is nonisolated and can be called from any context without await.
    /// The actual logging is dispatched asynchronously to all registered handlers.
    /// Use this method for potentially harmful situations that don't prevent
    /// the application from functioning but should be investigated.
    ///
    /// - Parameters:
    ///   - message: The log message describing the warning
    ///   - category: The category of the log event for filtering and organization
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters as Sendable values (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.warning("API response took longer than expected", category: .network, module: "APIClient", parameters: ["duration": 3.2])
    /// ```
    @discardableResult
    public nonisolated func warning(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Sendable] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) -> Task<Void, Never> {
        logSync(level: .warning, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }
    
    /// Logs an informational message.
    ///
    /// This method is nonisolated and can be called from any context without await.
    /// The actual logging is dispatched asynchronously to all registered handlers.
    /// Use this method for general informational messages that highlight
    /// the progress or state of the application.
    ///
    /// - Parameters:
    ///   - message: The log message describing the information
    ///   - category: The category of the log event for filtering and organization
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters as Sendable values (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.info("User successfully logged in", category: .domain, module: "UserModule", parameters: ["userId": 123, "username": "john"])
    /// ```
    @discardableResult
    public nonisolated func info(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Sendable] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) -> Task<Void, Never> {
        logSync(level: .info, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }
    
    /// Logs a debug message.
    ///
    /// This method is nonisolated and can be called from any context without await.
    /// The actual logging is dispatched asynchronously to all registered handlers.
    /// Use this method for detailed information typically useful only
    /// during development and debugging.
    ///
    /// - Parameters:
    ///   - message: The log message describing the debug information
    ///   - category: The category of the log event for filtering and organization
    ///   - module: The module name where the log originated
    ///   - parameters: Additional context parameters as Sendable values (default: empty dictionary)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///
    /// Example usage:
    /// ```swift
    /// logger.debug("Cache hit", category: .domain, module: "DataLayer", parameters: ["key": "user_profile", "size": 1024])
    /// ```
    @discardableResult
    public nonisolated func debug(
        _ message: String,
        category: LogCategory,
        module: String,
        parameters: [String: Sendable] = [:],
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) -> Task<Void, Never> {
        logSync(level: .debug, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
    }

    private nonisolated func logSync(
        level: LogLevel,
        message: String,
        parameters: [String: Sendable],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) -> Task<Void, Never> {
        return Task {
            await log(level: level, message: message, parameters: parameters, category: category, module: module, file: file, line: line, function: function)
        }
    }

    private func log(
        level: LogLevel,
        message: String,
        parameters: [String: Sendable],
        category: LogCategory,
        module: String,
        file: String,
        line: Int,
        function: String
    ) async {
        await withDiscardingTaskGroup { group in
            handlers.forEach { handler in
                group.addImmediateTask {
                    await handler.log(
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
    }
}
