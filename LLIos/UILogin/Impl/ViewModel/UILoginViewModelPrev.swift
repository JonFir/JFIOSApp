import SwiftUI

@Observable
final class UILoginViewModelPrev: UILoginViewModel {
    var email: String = "preview@example.com"
    var password: String = "password"
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    func login() {}
    func navigateToRegistration() {}
}

