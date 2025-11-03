import UIKit

class ApplicationDelegate: NSObject, UIApplicationDelegate {


    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )

        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
            configuration.sceneClass = Scene.self
        }

        return configuration
    }
    
}

