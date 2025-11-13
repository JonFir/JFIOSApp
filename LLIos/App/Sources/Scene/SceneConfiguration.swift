import UIKit

final class SceneConfiguration: UISceneConfiguration {
    init(
        session: UISceneSession,
        options: UIScene.ConnectionOptions,
    ) {
        super.init(
            name: "Default Configuration",
            sessionRole: session.role
        )

        if session.role == .windowApplication {
            self.delegateClass = SceneDelegate.self
            self.sceneClass = Scene.self
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
