//
//  LogMessageFormatter.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Foundation
import Logger

private let timestampFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return formatter
}()

/// Formats log messages with all relevant information.
///
/// Creates a structured log message that includes timestamp, level, module,
/// category, message text, parameters, and source code location.
///
/// Example usage:
/// ```swift
/// let formatted = formatLogMessage(
///     level: .info,
///     message: "User logged in",
///     parameters: ["userId": 123],
///     category: .domain,
///     module: "UserModule",
///     file: "LoginViewController.swift",
///     line: 45,
///     function: "handleLogin()"
/// )
/// ```
func formatLogMessage(
    level: LogLevel,
    message: String,
    parameters: [String: Any],
    category: LogCategory,
    module: String,
    file: String,
    line: Int,
    function: String
) -> String {
    let timestamp = formatTimestamp(Date())
    let levelString = formatLogLevel(level)
    let parametersString = formatParameters(parameters)
    
    return """
    \(timestamp) [\(levelString)] [\(module)] [\(category.rawValue)] \(message)
    Parameters: \(parametersString)
    Location: \(file):\(line) \(function)
    """
}

private func formatTimestamp(_ date: Date) -> String {
    timestampFormatter.string(from: date)
}

private func formatLogLevel(_ level: LogLevel) -> String {
    switch level {
    case .critical:
        return "CRITICAL"
    case .warning:
        return "WARNING"
    case .info:
        return "INFO"
    case .debug:
        return "DEBUG"
    }
}

private func formatParameters(_ parameters: [String: Any]) -> String {
    guard !parameters.isEmpty else {
        return "none"
    }
    
    let items = parameters.map { key, value in
        "\(key)=\(value)"
    }.joined(separator: ", ")
    
    return items
}
