import UIKit
import SwiftUI
import FactoryKit

/// Factory provider for UIRegistration view controller
///
/// Example usage:
/// ```swift
/// let registrationVC = Container.shared.uiRegistrationViewController()
/// navigationController.pushViewController(registrationVC, animated: true)
/// ```
extension Container {
    public var uiRegistrationViewController: Factory<UIRegistrationViewController?> { promised() }
}

/// Protocol for registration screen view controller
public protocol UIRegistrationViewController: UIViewController {}





