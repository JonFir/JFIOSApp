import FactoryKit
import UISplash
import LibUIKit
import SwiftUI

public class UISplashAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.uiSplashViewController.register { @MainActor in
            BaseViewController(view: UISplashView())
        }
    }
}

struct UISplashView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
