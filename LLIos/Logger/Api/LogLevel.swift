//
//  LogLevel.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Foundation

/// Represents the severity level of a log message.
///
/// The log levels are ordered from most to least severe:
/// - `critical`: Critical errors that require immediate attention
/// - `warning`: Warning messages for potentially harmful situations
/// - `info`: Informational messages for general application flow
/// - `debug`: Detailed debug information for development
public enum LogLevel: Sendable {
    case critical
    case warning
    case info
    case debug
}

