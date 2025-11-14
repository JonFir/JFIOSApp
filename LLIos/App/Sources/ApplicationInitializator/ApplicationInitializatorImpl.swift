import UIKit
import Logger
import FirstModule
import FactoryKit

extension Container {
    @MainActor
    var applicationInitializator: Factory<ApplicationInitializator> { self { @MainActor in ApplicationInitializatorImpl() } }
}

final class ApplicationInitializatorImpl: ApplicationInitializator {

    @LazyInjected(\.mainWindow) var window
    @Injected(\.logger) var logger

    private var isShown: Bool = false

    func beforeAppRun() {
        logger?.info("application will run at first time", category: .system, module: "App")
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        logger?.info("Make main UIWindow", category: .ui, module: "App")
        if let windowScene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            Container.shared.mainWindow.register { window }
            window.rootViewController = Container.shared.firstModuleViewController()
            window.makeKeyAndVisible()
        } else {
            logger?.critical("Fail to make main UIWindow", category: .ui, module: "App", parameters: ["scene is": "\(scene)"])
        }
    }

    func beforeShow(_ scene: UIScene) {
        guard !isShown else { return }
        isShown = true
        logger?.info("application will show at first time", category: .system, module: "App")
    }
}
