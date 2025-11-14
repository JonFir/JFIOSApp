//
//  LoggerTests.swift
//  LLIos
//
//  Created by Evgeniy Yolchev on 05.11.2025.
//

import Testing
@testable import Logger

struct LoggerTests {
    
    @Test
    func logsMessageWithCorrectMetadata() async {
        let mockHandler = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler])
        
        await logger.info("Test message", category: .domain, module: "TestModule").value

        let callCount = await mockHandler.logCallCount
        let entries = await mockHandler.loggedEntries
        
        #expect(callCount == 1)
        #expect(entries.first?.level == .info)
        #expect(entries.first?.message == "Test message")
        #expect(entries.first?.category == .domain)
        #expect(entries.first?.module == "TestModule")
    }
    
    @Test
    func logsParameters() async {
        let mockHandler = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler])
        
        let parameters: [String: any Sendable] = ["userId": 123, "userName": "John"]
        
        await logger.info("Test message", category: .domain, module: "TestModule", parameters: parameters).value

        let entries = await mockHandler.loggedEntries
        
        guard let loggedEntry = entries.first else {
            Issue.record("No entry logged")
            return
        }
        
        #expect(loggedEntry.parameters["userId"] as? Int == 123)
        #expect(loggedEntry.parameters["userName"] as? String == "John")
    }
    
    @Test
    func logsFileLineFunction() async {
        let mockHandler = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler])
        
        await logger.info("Test message", category: .ui, module: "TestModule").value
        
        let entries = await mockHandler.loggedEntries
        
        guard let loggedEntry = entries.first else {
            Issue.record("No entry logged")
            return
        }
        
        #expect(loggedEntry.file.contains("LoggerTests.swift"))
        #expect(loggedEntry.line > 0)
        #expect(loggedEntry.function == "logsFileLineFunction()")
    }
    
    @Test
    func multipleHandlersReceiveLog() async {
        let mockHandler1 = LoggerHandlerMock()
        let mockHandler2 = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler1, mockHandler2])
        
        await logger.info("Test message", category: .ui, module: "TestModule").value
        
        let callCount1 = await mockHandler1.logCallCount
        let callCount2 = await mockHandler2.logCallCount
        let entries1 = await mockHandler1.loggedEntries
        let entries2 = await mockHandler2.loggedEntries
        
        #expect(callCount1 == 1)
        #expect(callCount2 == 1)
        #expect(entries1.first?.message == "Test message")
        #expect(entries2.first?.message == "Test message")
    }
    
    @Test
    func noHandlersDoesNotCrash() async {
        let logger = Logger(handlers: [])
        
        await logger.info("Test message", category: .ui, module: "TestModule").value
    }
    
    @Test
    func multipleLogsAreStoredInOrder() async {
        let mockHandler = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler])
        
        async let debug = logger.debug("First", category: .ui, module: "Module1").result
        async let info = logger.info("Second", category: .network, module: "Module2").result
        async let warning = logger.warning("Third", category: .domain, module: "Module3").result
        async let critical = logger.critical("Fourth", category: .routing, module: "Module4").result

        let _ = await (debug, info, warning, warning, critical)
        
        let callCount = await mockHandler.logCallCount
        let entries = await mockHandler.loggedEntries
        
        #expect(callCount == 4)
        #expect(entries.count == 4)
        
        #expect(entries[0].message == "First")
        #expect(entries[0].level == .debug)
        
        #expect(entries[1].message == "Second")
        #expect(entries[1].level == .info)
        
        #expect(entries[2].message == "Third")
        #expect(entries[2].level == .warning)
        
        #expect(entries[3].message == "Fourth")
        #expect(entries[3].level == .critical)
    }
    
    @Test
    func onLogClosureIsCalled() async {
        let mockHandler = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler])
        
        nonisolated(unsafe) var closureCallCount = 0
        nonisolated(unsafe) var capturedMessage: String?

        await mockHandler.setOnLog { _, message, _, _, _, _, _, _ in
            closureCallCount += 1
            capturedMessage = message
        }
        
        await logger.info("Test message", category: .ui, module: "TestModule").value
        
        #expect(closureCallCount == 1)
        #expect(capturedMessage == "Test message")
    }
    
    @Test
    func resetClearsMockState() async {
        let mockHandler = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler])

        await logger.info("First message", category: .ui, module: "TestModule").value
        await logger.info("Second message", category: .ui, module: "TestModule").value
        
        let callCountBefore = await mockHandler.logCallCount
        let entriesBefore = await mockHandler.loggedEntries
        
        #expect(callCountBefore == 2)
        #expect(entriesBefore.count == 2)
        
        await mockHandler.reset()
        
        let callCountAfter = await mockHandler.logCallCount
        let entriesAfter = await mockHandler.loggedEntries
        
        #expect(callCountAfter == 0)
        #expect(entriesAfter.count == 0)
    }
    
    @Test
    func emptyParametersByDefault() async {
        let mockHandler = LoggerHandlerMock()
        let logger = Logger(handlers: [mockHandler])
        
        await logger.info("Test message", category: .ui, module: "TestModule").value
        
        let entries = await mockHandler.loggedEntries
        
        guard let loggedEntry = entries.first else {
            Issue.record("No entry logged")
            return
        }
        
        #expect(loggedEntry.parameters.isEmpty)
    }
}
