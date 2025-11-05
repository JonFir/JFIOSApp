//
//  LoggerTests.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import XCTest
@testable import Logger

final class LoggerTests: XCTestCase {
    
    var sut: Logger!
    var mockHandler: LoggerHandlerMock!
    
    override func setUp() {
        super.setUp()
        sut = Logger()
        mockHandler = LoggerHandlerMock()
        sut.handlers = [mockHandler]
    }
    
    override func tearDown() {
        sut = nil
        mockHandler = nil
        super.tearDown()
    }
    
    func testLogsMessageWithCorrectMetadata() {
        sut.info("Test message", category: .domain, module: "TestModule")
        
        XCTAssertEqual(mockHandler.logCallCount, 1)
        XCTAssertEqual(mockHandler.loggedEntries.first?.level, .info)
        XCTAssertEqual(mockHandler.loggedEntries.first?.message, "Test message")
        XCTAssertEqual(mockHandler.loggedEntries.first?.category, .domain)
        XCTAssertEqual(mockHandler.loggedEntries.first?.module, "TestModule")
    }
    
    func testLogsParameters() {
        let parameters: [String: Any] = ["userId": 123, "userName": "John"]
        
        sut.info("Test message", category: .domain, module: "TestModule", parameters: parameters)
        
        guard let loggedEntry = mockHandler.loggedEntries.first else {
            XCTFail("No entry logged")
            return
        }
        
        XCTAssertEqual(loggedEntry.parameters["userId"] as? Int, 123)
        XCTAssertEqual(loggedEntry.parameters["userName"] as? String, "John")
    }
    
    func testLogsFileLineFunction() {
        sut.info("Test message", category: .ui, module: "TestModule")
        
        guard let loggedEntry = mockHandler.loggedEntries.first else {
            XCTFail("No entry logged")
            return
        }
        
        XCTAssertTrue(loggedEntry.file.contains("LoggerTests.swift"))
        XCTAssertGreaterThan(loggedEntry.line, 0)
        XCTAssertEqual(loggedEntry.function, "testLogsFileLineFunction()")
    }
    
    func testMultipleHandlersReceiveLog() {
        let secondMockHandler = LoggerHandlerMock()
        sut.handlers = [mockHandler, secondMockHandler]
        
        sut.info("Test message", category: .ui, module: "TestModule")
        
        XCTAssertEqual(mockHandler.logCallCount, 1)
        XCTAssertEqual(secondMockHandler.logCallCount, 1)
        XCTAssertEqual(mockHandler.loggedEntries.first?.message, "Test message")
        XCTAssertEqual(secondMockHandler.loggedEntries.first?.message, "Test message")
    }
    
    func testNoHandlersDoesNotCrash() {
        sut.handlers = []
        
        XCTAssertNoThrow(sut.info("Test message", category: .ui, module: "TestModule"))
    }
    
    func testMultipleLogsAreStoredInOrder() {
        sut.debug("First", category: .ui, module: "Module1")
        sut.info("Second", category: .network, module: "Module2")
        sut.warning("Third", category: .domain, module: "Module3")
        sut.critical("Fourth", category: .routing, module: "Module4")
        
        XCTAssertEqual(mockHandler.logCallCount, 4)
        XCTAssertEqual(mockHandler.loggedEntries.count, 4)
        
        XCTAssertEqual(mockHandler.loggedEntries[0].message, "First")
        XCTAssertEqual(mockHandler.loggedEntries[0].level, .debug)
        
        XCTAssertEqual(mockHandler.loggedEntries[1].message, "Second")
        XCTAssertEqual(mockHandler.loggedEntries[1].level, .info)
        
        XCTAssertEqual(mockHandler.loggedEntries[2].message, "Third")
        XCTAssertEqual(mockHandler.loggedEntries[2].level, .warning)
        
        XCTAssertEqual(mockHandler.loggedEntries[3].message, "Fourth")
        XCTAssertEqual(mockHandler.loggedEntries[3].level, .critical)
    }
    
    func testOnLogClosureIsCalled() {
        var closureCallCount = 0
        var capturedMessage: String?
        
        mockHandler.onLog = { _, message, _, _, _, _, _, _ in
            closureCallCount += 1
            capturedMessage = message
        }
        
        sut.info("Test message", category: .ui, module: "TestModule")
        
        XCTAssertEqual(closureCallCount, 1)
        XCTAssertEqual(capturedMessage, "Test message")
    }
    
    func testResetClearsMockState() {
        sut.info("First message", category: .ui, module: "TestModule")
        sut.info("Second message", category: .ui, module: "TestModule")
        
        XCTAssertEqual(mockHandler.logCallCount, 2)
        XCTAssertEqual(mockHandler.loggedEntries.count, 2)
        
        mockHandler.reset()
        
        XCTAssertEqual(mockHandler.logCallCount, 0)
        XCTAssertEqual(mockHandler.loggedEntries.count, 0)
    }
    
    func testEmptyParametersByDefault() {
        sut.info("Test message", category: .ui, module: "TestModule")
        
        guard let loggedEntry = mockHandler.loggedEntries.first else {
            XCTFail("No entry logged")
            return
        }
        
        XCTAssertTrue(loggedEntry.parameters.isEmpty)
    }
}

