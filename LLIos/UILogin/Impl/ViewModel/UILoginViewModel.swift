import SwiftUI
import LibSwiftUI

/// View model protocol for login screen
@MainActor
protocol UILoginViewModel: Observable, AnyObject {
    var email: VMField<String> { get set }
    var password: VMField<String> { get set }
    var isLoading: Bool { get }
    var errorMessage: (String, String?)? { get }
    
    func login()
    func navigateToRegistration()
}
