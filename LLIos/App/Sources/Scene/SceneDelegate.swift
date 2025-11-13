import UIKit
import SwiftUI
import FirstModule
import Logger
import FactoryKit

class SceneDelegate: NSObject, UISceneDelegate {
    @Injected(\.mainWindow) var window
    @Injected(\.logger) var logger
    @Injected(\.applicationInitializator) var applicationInitializator

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        applicationInitializator.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        applicationInitializator.beforeShow(scene)
    }
    
}
