import UIDashbord
import SwiftUI
import LibUIKit
import Logger
import Navigator
import FactoryKit

/// Implementation of dashboard view controller
final class UIDashboardViewControllerImpl: BaseViewController, UIDashboardViewController {
    @LazyInjected(\.appNavigator) var navigator
    @LazyInjected(\.logger) var logger

    func replaceAppFlow() {
        guard let vc = Container.shared.uiDashboardViewController() else {
            logger?.critical("can't show dashboard view controller", category: .ui, module: "UIDashbord")
            return
        }
        navigator?.replace([vc], animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger?.info("Dashboard.Screen.Shown", category: .ui, module: "UIDashbord")
    }
}

