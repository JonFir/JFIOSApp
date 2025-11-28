import FactoryKit
import UIKit

extension Container {
    public var appNavigator: Factory<AppNavigator?> { promised() }
}

@MainActor
public protocol AppNavigator: AnyObject {

    func push(_ viewController: UIViewController, animated: Bool)
    func replace(_ viewControllers: [UIViewController], animated: Bool)

    func setup()
}
