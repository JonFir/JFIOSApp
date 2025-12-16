import UILogin
import SwiftUI
import LibUIKit
import Logger
import Navigator
import FactoryKit

final class UILoginViewControllerImpl: BaseViewController, UILoginViewController {
    @LazyInjected(\.appNavigator) var navigator
    @LazyInjected(\.logger) var logger

    func replaceAppFlow() {
        navigator?.replace([self], animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger?.info("Login.Screen.Shown", category: .ui, module: "UILogin")
    }
}
