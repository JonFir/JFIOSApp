import Navigator
import FactoryKit
import LibUIKit
import UISplash
import Logger
import UIKit

final class AppNavigatorImpl: AppNavigator {
    @LazyInjected(\.mainWindow) var mainWindow
    @LazyInjected(\.mainViewController) var mainViewController
    @LazyInjected(\.logger) var logger

    func setup() {
        guard let mainWindow else { return }
        mainWindow.rootViewController = mainViewController
        mainWindow.makeKeyAndVisible()
        Container.shared.uiSplashViewController()?.replaceAppFlow()
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        mainViewController.pushViewController(viewController, animated: animated)
    }

    func replace(_ viewControllers: [UIViewController], animated: Bool) {
        mainViewController.setViewControllers(viewControllers, animated: animated)
    }

}
