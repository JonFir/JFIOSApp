import SwiftUI

@Observable
final class UILoginViewModelPrev: UILoginViewModel {
    var email: String = "preview@example.com"
    var password: String = "password"
    var isLoading: Bool = false
    var errorMessage: (String, String?)?

    func login() {
        if errorMessage == nil {
            errorMessage = (
                "Пользователь не найден",
                "Пользователь с таким `email` не зарегистрирован или указан неверный пароль"
            )
        } else {
            errorMessage = nil
        }
    }
    func navigateToRegistration() {}
}
