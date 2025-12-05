import SwiftUI
import FactoryKit
import LibSwift

/// Factory provider for UILogin view model
extension Container {
    @MainActor
    var uiLoginViewModel: Factory<UILoginViewModel> {
        self { @MainActor in UILoginViewModelImpl() }
    }
}

/// Implementation of login screen view model
@Observable
final class UILoginViewModelImpl: UILoginViewModel {
    
    var email = VMField<String>("") { text in
        if (try? text.matches(#"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#)) == true {
            return .value(text)
        } else {
            return .error("Isn't a valid email")
        }
    }
    var password = VMField<String>("") { text in
        if (try? text.matches(#"^(?=.*[A-ZА-Я])(?=.*[a-zа-я])(?=.*\d)(?=.*[^A-Za-zА-Яа-я0-9]).{12,}$"#)) == true {
            return .value(text)
        } else {
            return .error("Isn't a valid email")
        }

    }
    var isLoading: Bool = false
    var errorMessage: (String, String?)?

    init() {}
    
    func login() {
        email.updateValue()
        password.updateValue()

        guard
            let email = email.value.value,
            let password = password.value.value
        else {
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
        // Navigation to registration screen will be implemented
    }

}
