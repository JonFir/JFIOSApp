import SwiftUI
import LibSwiftUI

@Observable
final class UILoginViewModelPrev: UILoginViewModel {
    var email = "preview@example.com"
    var password = "preview@example.com"
    var isLoading: Bool = false
    var errorMessage: UILoginViewModelError?

    func login() {
        if errorMessage == nil {
            errorMessage = UILoginViewModelError(
                "Пользователь не найден",
                "Пользователь с таким `email` не зарегистрирован или указан неверный пароль"
            )
        } else {
            errorMessage = nil
        }
    }
    func navigateToRegistration() {}
}
