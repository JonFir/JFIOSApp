import UIKit

@MainActor
protocol ApplicationInitializator: AnyObject {
    func beforeAppRun()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    )

    func beforeShow(_ scene: UIScene)
}
