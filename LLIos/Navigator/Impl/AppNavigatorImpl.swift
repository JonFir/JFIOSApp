import Navigator
import FactoryKit
import LibUIKit
import UISplash
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

}
