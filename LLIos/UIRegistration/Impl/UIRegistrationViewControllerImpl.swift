import UIRegistration
import SwiftUI
import FactoryKit
import Navigator
import Logger

/// Implementation of registration view controller using SwiftUI hosting
final class UIRegistrationViewControllerImpl: UIHostingController<UIRegistrationView>, UIRegistrationViewController {
    @LazyInjected(\.appNavigator) var navigator
    @LazyInjected(\.logger) var logger

    func show() {
        navigator?.push(self, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger?.info("Registration.Screen.Shown", category: .ui, module: "UIRegistration")
    }
}
