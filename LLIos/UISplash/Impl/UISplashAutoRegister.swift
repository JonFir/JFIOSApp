import FactoryKit
import UISplash
import LibUIKit
import SwiftUI

public class UISplashAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.uiSplashViewController.register { @MainActor in
            UISplashViewControllerImpl(view: UISplashView())
        }
    }
}
