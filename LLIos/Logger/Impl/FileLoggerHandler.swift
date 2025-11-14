@preconcurrency import Foundation
import Logger

/// File-based logger handler that writes logs to daily files with automatic rotation.
///
/// This handler stores logs in separate files for each day in the Library/Caches/Logs directory.
/// It automatically rotates logs by keeping only the last 7 days of log files.
/// Provides methods to retrieve and clear logs through the FileLogHandling protocol.
///
/// Example usage:
/// ```swift
/// let handler = FileLoggerHandler()
/// let logger = Logger(handlers: [handler])
/// logger.info("User action", category: .domain, module: "UserModule")
///
/// let todayLogs = try handler.getTodayLogs()
/// let allLogs = try handler.getAllLogs()
/// try handler.clearLogs()
/// ```
final class FileLoggerHandler: LoggerHandler, FileLogHandling {

    nonisolated(unsafe) private let fileManager = FileManager.default
    private let dateFormatter: DateFormatter
    private let logsDirectory: URL
    private let maxLogDays = 7
    
    init?() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }

        self.logsDirectory = cachesDirectory.appendingPathComponent("Logs", isDirectory: true)
        
        createLogsDirectoryIfNeeded()
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
    ) async {
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
        
        writeLog(formattedMessage)
    }
    
    func getAllLogs() throws -> Data {
        let logFiles = try getLogFiles()
        var allLogsContent = ""
        
        for fileURL in logFiles.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            allLogsContent += content
            allLogsContent += "\n"
        }
        
        return allLogsContent.data(using: .utf8) ?? Data()
    }
    
    func getTodayLogs() throws -> Data {
        let todayFileName = logFileName(for: Date())
        let todayFileURL = logsDirectory.appendingPathComponent(todayFileName)
        
        guard fileManager.fileExists(atPath: todayFileURL.path) else {
            return Data()
        }
        
        let content = try String(contentsOf: todayFileURL, encoding: .utf8)
        return content.data(using: .utf8) ?? Data()
    }
    
    func clearLogs() throws {
        let logFiles = try getLogFiles()
        
        for fileURL in logFiles {
            try fileManager.removeItem(at: fileURL)
        }
    }

    /// Performs log rotation by removing files older than retention period.
    ///
    /// Scans the logs directory and deletes any log files that are older than
    /// the configured maximum retention period (7 days). Files are identified
    /// by their date suffix in the filename (log-YYYY-MM-dd.txt format).
    ///
    /// - Throws: Error if unable to read log directory or delete old files
    func performLogRotation() throws {
        let logFiles = try getLogFiles()
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -maxLogDays, to: Date()) ?? Date()

        for fileURL in logFiles {
            if let fileDate = extractDate(from: fileURL.lastPathComponent),
               fileDate < cutoffDate {
                try fileManager.removeItem(at: fileURL)
            }
        }
    }

    private func createLogsDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: logsDirectory.path) {
            try? fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true)
        }
    }
    
    private func writeLog(_ message: String) {
        let fileName = logFileName(for: Date())
        let fileURL = logsDirectory.appendingPathComponent(fileName)
        
        let logEntry = message + "\n\n"
        
        if fileManager.fileExists(atPath: fileURL.path) {
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                defer { try? fileHandle.close() }
                fileHandle.seekToEndOfFile()
                if let data = logEntry.data(using: .utf8) {
                    fileHandle.write(data)
                }
            }
        } else {
            try? logEntry.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
    
    private func getLogFiles() throws -> [URL] {
        guard fileManager.fileExists(atPath: logsDirectory.path) else {
            return []
        }
        
        let files = try fileManager.contentsOfDirectory(
            at: logsDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        
        return files.filter { $0.pathExtension == "txt" && $0.lastPathComponent.hasPrefix("log-") }
    }
    
    private func logFileName(for date: Date) -> String {
        "log-\(dateFormatter.string(from: date)).txt"
    }
    
    private func extractDate(from fileName: String) -> Date? {
        let dateString = fileName
            .replacingOccurrences(of: "log-", with: "")
            .replacingOccurrences(of: ".txt", with: "")
        return dateFormatter.date(from: dateString)
    }
}
