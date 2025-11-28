import SwiftUI

/// View model protocol for login screen
@MainActor
protocol UILoginViewModel: Observable, AnyObject {
    var email: String { get set }
    var password: String { get set }
    var isLoading: Bool { get }
    var errorMessage: (String, String?)? { get }
    
    func login()
    func navigateToRegistration()
}

