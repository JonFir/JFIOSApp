import FactoryKit
import UIKit

public final class UIRegistrationAutoRegister: AutoRegistering {
    
    public init() {}
    
    public func autoRegister() {
        Container.shared.uiRegistrationViewController.register { @MainActor in
            return UIRegistrationViewControllerImpl(rootView: UIRegistrationView())
        }
    }
}
