import UIKit
import Logger
import FactoryKit

class ApplicationDelegate: NSObject, UIApplicationDelegate {

    @LazyInjected(\.applicationInitializator) var applicationInitializator

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        applicationInitializator.beforeAppRun()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return SceneConfiguration(
            session: connectingSceneSession,
            options: options
        )
    }
    
}

