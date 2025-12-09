import SwiftUI
import LibSwiftUI

/// View model protocol for login screen
@MainActor
protocol UILoginViewModel: Observable, AnyObject {
    var email: String { get set }
    var password: String { get set }
    var isLoading: Bool { get }
    var errorMessage: UILoginViewModelError? { get }
    
    func login() async
    func navigateToRegistration()
}

struct UILoginViewModelError: Error, Equatable, Sendable {
    let title: String
    let subtitle: String?

    init(_ title: String, _ subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }

    static var unknown: UILoginViewModelError {
        UILoginViewModelError(
            String(localized: "error.unknown.title", bundle: .module),
            String(localized: "error.unknown.subtitle", bundle: .module)
        )
    }
}
