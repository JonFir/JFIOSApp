//
//  LogMessageFormatterTests.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Testing
import Foundation
@testable import Logger
@testable import LoggerImpl

@Suite
struct LogMessageFormatterTests {
    
    @Test
    func formatLogMessageWithAllArguments() {
        let message = formatLogMessage(
            level: .warning,
            message: "Test message",
            parameters: ["key": "value"],
            category: .network,
            module: "TestModule",
            file: "TestFile.swift",
            line: 123,
            function: "testFunc()"
        )
        
        let lines = message.split(separator: "\n")
        
        #expect(lines.count == 3)
        #expect(lines[0].hasSuffix(" [WARNING] [TestModule] [Network] Test message"))
        #expect(String(lines[1]) == "Parameters: key=value")
        #expect(String(lines[2]) == "Location: TestFile.swift:123 testFunc()")
    }
    
    @Test
    func formatLogMessageWithEmptyParameters() {
        let message = formatLogMessage(
            level: .info,
            message: "Simple message",
            parameters: [:],
            category: .domain,
            module: "Module",
            file: "File.swift",
            line: 5,
            function: "func()"
        )
        
        let lines = message.split(separator: "\n")
        
        #expect(lines.count == 3)
        #expect(lines[0].hasSuffix(" [INFO] [Module] [Domain] Simple message"))
        #expect(String(lines[1]) == "Parameters: none")
        #expect(String(lines[2]) == "Location: File.swift:5 func()")
    }
    
    @Test
    func formatLogMessageWithMultipleParameters() {
        let message = formatLogMessage(
            level: .debug,
            message: "Request completed",
            parameters: ["status": 200, "duration": 1.5],
            category: .network,
            module: "APIClient",
            file: "API.swift",
            line: 25,
            function: "handleResponse()"
        )
        
        let lines = message.split(separator: "\n")
        
        #expect(lines.count == 3)
        #expect(lines[0].hasSuffix(" [DEBUG] [APIClient] [Network] Request completed"))
        
        let parametersLine = String(lines[1])
        #expect(parametersLine.hasPrefix("Parameters: "))
        #expect(parametersLine.contains("status=200"))
        #expect(parametersLine.contains("duration=1.5"))
        
        #expect(String(lines[2]) == "Location: API.swift:25 handleResponse()")
    }
    
    @Test
    func formatLogMessageTimestampFormat() {
        let message = formatLogMessage(
            level: .critical,
            message: "Test",
            parameters: [:],
            category: .routing,
            module: "TestModule",
            file: "Test.swift",
            line: 1,
            function: "test()"
        )
        
        let timestampRegex = try! NSRegularExpression(
            pattern: "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}\\.\\d{3} ",
            options: []
        )
        
        let range = NSRange(message.startIndex..., in: message)
        let match = timestampRegex.firstMatch(in: message, options: [], range: range)
        
        #expect(match != nil)
    }
}

