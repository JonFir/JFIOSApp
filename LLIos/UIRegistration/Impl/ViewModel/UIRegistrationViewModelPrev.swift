import SwiftUI

@Observable
final class UIRegistrationViewModelPrev: UIRegistrationViewModel {
    var email: String = "preview@example.com"
    var password: String = "password"
    var confirmPassword: String = "password"
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    func register() {}
}

