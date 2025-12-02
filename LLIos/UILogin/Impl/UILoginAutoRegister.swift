import FactoryKit
import UIKit

/// Auto-registration class for UILogin module dependencies
///
/// Registers the login view controller in the dependency injection container.
public final class UILoginAutoRegister: AutoRegistering {
    
    public init() {}
    
    public func autoRegister() {
        Container.shared.uiLoginViewController.register { @MainActor in
            return UILoginViewControllerImpl(view: UILoginView())
        }
    }
}
