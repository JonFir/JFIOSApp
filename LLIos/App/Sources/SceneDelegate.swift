import UIKit
import SwiftUI
import FirstModuleImpl

class SceneDelegate: NSObject, UISceneDelegate {
    private var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let factory = FirstModuleFactoryImpl()

        window.rootViewController = factory.makeFirstScreen(title: "Привет!")
        window.makeKeyAndVisible()
        self.window = window
    }
}
