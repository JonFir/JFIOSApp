import Testing
@testable import AccountStorage
import Foundation

@Suite("AccountTests")
final class AccountTests {
    
    init() {
    }
    
    deinit {
    }
    
    // Test: isExpiredToken returns false when token is valid (expiration far in future)
    // Mock:
    // - None
    // Setup:
    // - Create Account with expiration far in future (more than 2 days from now)
    // Verify:
    // - isExpiredToken() returns false
    @Test("Token is valid when expiration is far in future")
    func testIsExpiredTokenReturnsFalseForValidToken() {
        let expiration = Date.now.timeIntervalSince1970 + 60 * 60 * 24 * 3
        let account = Account(
            id: "test-id",
            email: nil,
            name: nil,
            token: "test-token",
            expiration: expiration
        )
        
        #expect(!account.isExpiredToken())
    }
    
    // Test: isExpiredToken returns true when token expires soon (less than 2 days)
    // Mock:
    // - None
    // Setup:
    // - Create Account with expiration less than 2 days from now
    // Verify:
    // - isExpiredToken() returns true
    @Test("Token is expired when expiration is less than 2 days")
    func testIsExpiredTokenReturnsTrueForSoonExpiringToken() {
        let expiration = Date.now.timeIntervalSince1970 + 60 * 60 * 24
        let account = Account(
            id: "test-id",
            email: nil,
            name: nil,
            token: "test-token",
            expiration: expiration
        )
        
        #expect(account.isExpiredToken())
    }
    
    // Test: isExpiredToken returns true when token already expired
    // Mock:
    // - None
    // Setup:
    // - Create Account with expiration in the past
    // Verify:
    // - isExpiredToken() returns true
    @Test("Token is expired when expiration is in the past")
    func testIsExpiredTokenReturnsTrueForExpiredToken() {
        let expiration = Date.now.timeIntervalSince1970 - 60 * 60 * 24
        let account = Account(
            id: "test-id",
            email: nil,
            name: nil,
            token: "test-token",
            expiration: expiration
        )
        
        #expect(account.isExpiredToken())
    }
}
