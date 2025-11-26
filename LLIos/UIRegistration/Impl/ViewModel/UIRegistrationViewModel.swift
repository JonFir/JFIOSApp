import SwiftUI

/// View model protocol for registration screen
@MainActor
protocol UIRegistrationViewModel: Observable, AnyObject {
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func register()
}

