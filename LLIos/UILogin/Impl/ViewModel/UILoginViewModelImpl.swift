import SwiftUI
import FactoryKit

/// Factory provider for UILogin view model
extension Container {
    @MainActor
    var uiLoginViewModel: Factory<UILoginViewModel> {
        self { @MainActor in UILoginViewModelImpl() }.shared
    }
}

/// Implementation of login screen view model
@Observable
final class UILoginViewModelImpl: UILoginViewModel {
    
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: (String, String?)?

    init() {}
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage?.0 = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            isLoading = false
        }
    }
    
    func navigateToRegistration() {
        // TODO: Implement navigation to registration screen
    }
}

