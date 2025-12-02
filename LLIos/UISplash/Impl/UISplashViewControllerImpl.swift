import UISplash
import SwiftUI
import LibUIKit
import Logger
import Navigator
import FactoryKit

final class UISplashViewControllerImpl: BaseViewController, UISplashViewController {
    @LazyInjected(\.appNavigator) var navigator
    @LazyInjected(\.logger) var logger
    
    func replaceAppFlow() {
        guard let splashVC = Container.shared.uiSplashViewController() else {
            logger?.critical("can't show splash", category: .ui, module: "Navigator")
            return
        }
        navigator?.replace([splashVC], animated: false)
    }

}
