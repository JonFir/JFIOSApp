import SwiftUI
import FactoryKit

/// Factory provider for UIRegistration view model
extension Container {
    @MainActor
    var uiRegistrationViewModel: Factory<UIRegistrationViewModel> {
        self { @MainActor in UIRegistrationViewModelImpl() }.shared
    }
}

/// Implementation of registration screen view model
@Observable
final class UIRegistrationViewModelImpl: UIRegistrationViewModel {
    
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    init() {}
    
    func register() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            isLoading = false
        }
    }
}
