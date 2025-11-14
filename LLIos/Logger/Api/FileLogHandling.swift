import Foundation
import FactoryKit

extension Container {
    public var fileLogHandling: Factory<FileLogHandling?> { promised() }
}

/// Protocol for accessing and managing file-based logs.
///
/// Provides methods to retrieve logs from file storage and clear them when needed.
/// Implementations should handle file I/O operations and ensure thread-safe access.
///
/// Example usage:
/// ```swift
/// let fileLogHandler = Container.shared.fileLogHandling()
/// let todayLogs = try await fileLogHandler?.getTodayLogs()
/// let allLogs = try await fileLogHandler?.getAllLogs()
/// try await fileLogHandler?.clearLogs()
/// ```
public protocol FileLogHandling: Sendable {
    /// Retrieves all log files content.
    ///
    /// - Returns: Data containing all logs from all available log files
    /// - Throws: Error if unable to read log files
    func getAllLogs() throws -> Data
    
    /// Retrieves today's log file content.
    ///
    /// - Returns: Data containing logs from today's log file
    /// - Throws: Error if unable to read today's log file
    func getTodayLogs() throws -> Data
    
    /// Clears all log files from storage.
    ///
    /// - Throws: Error if unable to delete log files
    func clearLogs() throws

    /// Performs log rotation by removing files older than retention period.
    ///
    /// Checks all log files in storage and removes those that exceed the maximum
    /// retention period (typically 7 days). This method can be called manually
    /// to free up storage space or clean up old logs.
    ///
    /// - Throws: Error if unable to read log directory or delete old files
    func performLogRotation() throws
}

