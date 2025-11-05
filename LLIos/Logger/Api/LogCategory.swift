//
//  LogCategory.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Foundation

/// Represents the category of a log message.
///
/// Categories help organize logs by functional area of the application,
/// making it easier to filter and analyze logs for specific subsystems.
///
/// Example usage:
/// ```swift
/// logger.info("Button tapped", category: .ui, module: "MainScreen")
/// logger.info("User created", category: .domain, module: "UserService")
/// logger.warning("Request timeout", category: .network, module: "APIClient")
/// ```
public enum LogCategory: String {
    case ui = "UI"
    case domain = "Domain"
    case network = "Network"
    case routing = "Routing"
}

