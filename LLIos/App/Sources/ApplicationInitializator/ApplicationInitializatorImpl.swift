import UIKit
import Logger
import FirstModule
import FactoryKit
import Settings
import LibSwift
import LibUIKit
import Navigator

extension Container {
    @MainActor
    var applicationInitializator: Factory<ApplicationInitializator> { self { @MainActor in ApplicationInitializatorImpl() } }
}

private enum ApplicationInitializatorAsyncSteps: Sendable, CaseIterable {
    case settings
}

/// Manages multi-stage application initialization process.
///
/// The initialization process consists of several strictly ordered stages:
/// 1. `beforeAppRun()` - Synchronous initialization of critical components
/// 2. `finalizeAppRun()` - Asynchronous parallel initialization tasks
/// 3. `beforeShow(_:)` - One-time synchronous setup before UI presentation
/// 4. `appliactionWillConfigured()` - Completion handler for all async tasks
///
/// Each async task updates its completion flag and triggers `appliactionWillConfigured()`
/// to verify if all required initialization steps are finished.
///
final class ApplicationInitializatorImpl: ApplicationInitializator {

    @LazyInjected(\.mainWindow) var window
    @LazyInjected(\.settingsProvider) var settingsProvider
    @LazyInjected(\.appNavigator) var appNavigator
    @Injected(\.logger) var logger

    private var settingsListener: AnySendableObject?
    private var isShown: Bool = false
    private var completedAsyncSteps: Set<ApplicationInitializatorAsyncSteps> = []
    private var isAppliactionConfigured: Bool = false

    /// Performs synchronous initialization of critical components required for app launch.
    ///
    /// This is the first initialization stage that sets up essential services without which
    /// the application cannot function properly, such as logging system and crash reporting.
    /// Must be completed before any other initialization stages.
    ///
    func beforeAppRun() {
        Container.shared.settingsRegisterTask().register()
        Container.shared.appMetricaRegisterTask()?.register()
        logger?.info("application will run at first time", category: .system, module: "App")
        finalizeAppRun()
    }

    /// Starts asynchronous initialization tasks that can run in parallel.
    ///
    /// This is the second initialization stage that begins non-blocking configuration operations.
    /// Each async task should track its completion status and call `appliactionWillConfigured()`
    /// when finished to check if all required tasks have completed.
    ///
    func finalizeAppRun() {
        Task {
            self.settingsListener = await settingsProvider?.subscribe { @MainActor [weak self] settings in
                guard
                    let self,
                    !self.completedAsyncSteps.contains(.settings),
                    settings.deviceID != nil
                else { return }

                self.completedAsyncSteps.insert(.settings)
                self.settingsListener = nil
                self.appliactionWillConfigured()
            }
        }
    }

    /// Performs one-time synchronous setup operations before presenting the UI.
    ///
    /// This method may be called multiple times for different scenes, but executes actions
    /// only once after the application launch. Uses internal flag to ensure single execution.
    ///
    func beforeShow(_ scene: UIScene) {
        guard !isShown else { return }
        isShown = true
        logger?.info("application will show at first time", category: .system, module: "App")
    }

    /// Checks and handles completion of all required asynchronous initialization tasks.
    ///
    /// This method is called by each async task after completion to verify if all mandatory
    /// initialization steps are finished. Executes only once when all required steps are completed,
    /// protected by the `isAppliactionConfigured` flag.
    ///
    func appliactionWillConfigured() {
        guard
            !isAppliactionConfigured,
            completedAsyncSteps.count == ApplicationInitializatorAsyncSteps.allCases.count
        else { return }
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            Container.shared.mainWindow.register { window }
            appNavigator?.setup()
        } else {
            logger?.critical("Fail to make main UIWindow", category: .ui, module: "App", parameters: ["scene is": "\(scene)"])
        }
    }

}
