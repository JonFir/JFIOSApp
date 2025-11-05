//
//  LogMessageFormatterTests.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import XCTest
@testable import Logger
@testable import LoggerImpl

final class LogMessageFormatterTests: XCTestCase {
    
    func testFormatLogMessageWithAllArguments() {
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
        
        XCTAssertEqual(lines.count, 3)
        XCTAssertTrue(lines[0].hasSuffix(" [WARNING] [TestModule] [Network] Test message"))
        XCTAssertEqual(String(lines[1]), "Parameters: key=value")
        XCTAssertEqual(String(lines[2]), "Location: TestFile.swift:123 testFunc()")
    }
    
    func testFormatLogMessageWithEmptyParameters() {
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
        
        XCTAssertEqual(lines.count, 3)
        XCTAssertTrue(lines[0].hasSuffix(" [INFO] [Module] [Domain] Simple message"))
        XCTAssertEqual(String(lines[1]), "Parameters: none")
        XCTAssertEqual(String(lines[2]), "Location: File.swift:5 func()")
    }
    
    func testFormatLogMessageWithMultipleParameters() {
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
        
        XCTAssertEqual(lines.count, 3)
        XCTAssertTrue(lines[0].hasSuffix(" [DEBUG] [APIClient] [Network] Request completed"))
        
        let parametersLine = String(lines[1])
        XCTAssertTrue(parametersLine.hasPrefix("Parameters: "))
        XCTAssertTrue(parametersLine.contains("status=200"))
        XCTAssertTrue(parametersLine.contains("duration=1.5"))
        
        XCTAssertEqual(String(lines[2]), "Location: API.swift:25 handleResponse()")
    }
    
    func testFormatLogMessageTimestampFormat() {
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
        
        XCTAssertNotNil(match)
    }
}

