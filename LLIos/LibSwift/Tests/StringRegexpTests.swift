import Testing
@testable import LibSwift
import Foundation

@Suite("String+Regexp Tests")
struct StringRegexpTests {
    @Test("Matches valid pattern")
    func matchesValidPattern() throws {
        let text = "Hello World"
        let pattern = "Hello"
        
        let result = try text.matches(pattern)
        
        #expect(result == true)
    }
    
    @Test("Does not match invalid pattern")
    func doesNotMatchInvalidPattern() throws {
        let text = "Hello World"
        let pattern = "Goodbye"
        
        let result = try text.matches(pattern)
        
        #expect(result == false)
    }
    
    @Test("Matches pattern at start")
    func matchesPatternAtStart() throws {
        let text = "Hello World"
        let pattern = "^Hello"
        
        let result = try text.matches(pattern)
        
        #expect(result == true)
    }
    
    @Test("Matches pattern at end")
    func matchesPatternAtEnd() throws {
        let text = "Hello World"
        let pattern = "World$"
        
        let result = try text.matches(pattern)
        
        #expect(result == true)
    }
    
    @Test("Matches pattern in middle")
    func matchesPatternInMiddle() throws {
        let text = "Hello World"
        let pattern = "lo Wo"
        
        let result = try text.matches(pattern)
        
        #expect(result == true)
    }
    
    @Test("Matches with case insensitive option")
    func matchesWithCaseInsensitiveOption() throws {
        let text = "Hello World"
        let pattern = "hello"
        
        let result = try text.matches(pattern, options: .caseInsensitive)
        
        #expect(result == true)
    }
    
    @Test("Does not match without case insensitive option")
    func doesNotMatchWithoutCaseInsensitiveOption() throws {
        let text = "Hello World"
        let pattern = "hello"
        
        let result = try text.matches(pattern)
        
        #expect(result == false)
    }
    
    @Test("Matches email pattern")
    func matchesEmailPattern() throws {
        let text = "user@example.com"
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        
        let result = try text.matches(pattern)
        
        #expect(result == true)
    }
    
    @Test("Does not match invalid email pattern")
    func doesNotMatchInvalidEmailPattern() throws {
        let text = "invalid-email"
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        
        let result = try text.matches(pattern)
        
        #expect(result == false)
    }
    
    @Test("Matches digit pattern")
    func matchesDigitPattern() throws {
        let text = "12345"
        let pattern = "^\\d+$"
        
        let result = try text.matches(pattern)
        
        #expect(result == true)
    }
    
    @Test("Throws error for invalid regex pattern")
    func throwsErrorForInvalidRegexPattern() {
        let text = "Hello World"
        let pattern = "[invalid"
        
        #expect(throws: (any Error).self) {
            try text.matches(pattern)
        }
    }
    
    @Test("Throws error for empty pattern")
    func throwsErrorForEmptyPattern() {
        let text = ""
        let pattern = ""
        
        #expect(throws: (any Error).self) {
            try text.matches(pattern)
        }
    }
    
    @Test("Matches pattern with special characters")
    func matchesPatternWithSpecialCharacters() throws {
        let text = "Price: $100.50"
        let pattern = "\\$\\d+\\.\\d+"
        
        let result = try text.matches(pattern)
        
        #expect(result == true)
    }
}

