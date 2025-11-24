import Navigator
import FactoryKit
import LibUIKit
import UISplash
import FirstModule
import Logger

final class AppNavigatorImpl: AppNavigator {
    @LazyInjected(\.mainWindow) var mainWindow
    @LazyInjected(\.mainViewController) var mainViewController
    @LazyInjected(\.logger) var logger

    func setup() {
        guard let mainWindow else { return }
        mainWindow.rootViewController = mainViewController
        mainWindow.makeKeyAndVisible()
        showSplash()
    }
    
    func showSplash() {
        guard let splashVC = Container.shared.uiSplashViewController() else {
            logger?.critical("can't show splash", category: .ui, module: "Navigator")
            return
        }
        mainViewController.setViewControllers([splashVC], animated: false)
    }
    
    func showAuthFlow() {
        guard let firstModuleVC = Container.shared.firstModuleViewController() else {
            logger?.critical("can't show auth flow", category: .ui, module: "Navigator")
            return
        }
        mainViewController.setViewControllers([firstModuleVC], animated: false)
    }
    
    func showMainFlow() {
        guard let firstModuleVC = Container.shared.firstModuleViewController() else {
            logger?.critical("can't show main flow", category: .ui, module: "Navigator")
            return
        }
        mainViewController.setViewControllers([firstModuleVC], animated: false)
    }

}
