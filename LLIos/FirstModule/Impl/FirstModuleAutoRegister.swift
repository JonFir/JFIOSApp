import FactoryKit
import Logger
import UIKit

public class FirstModuleAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.firstModuleViewController.register {
            return FirstModuleViewControllerImpl(rootView: FirstModuleView())
        }
    }
}
