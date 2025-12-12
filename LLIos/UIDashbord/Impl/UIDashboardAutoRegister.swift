import FactoryKit
import UIKit

/// Auto-registration class for UIDashbord module dependencies
///
/// Registers the dashboard view controller in the dependency injection container.
public final class UIDashboardAutoRegister: AutoRegistering {
    
    public init() {}
    
    public func autoRegister() {
        Container.shared.uiDashboardViewController.register { @MainActor in
            return UIDashboardViewControllerImpl(view: DashboardView())
        }
    }
}

