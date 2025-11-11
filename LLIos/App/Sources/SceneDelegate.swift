import UIKit
import SwiftUI
import FirstModule
import FactoryImpl

class SceneDelegate: NSObject, UISceneDelegate {
    private var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        #if QA
        print("QA mode")
        #endif
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let viewController = assembler.resolver.resolve(FirstModuleViewController.self)!

        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
