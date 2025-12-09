import UIKit
import SwiftUI
import FactoryKit

extension Container {
    public var uiRegistrationViewController: Factory<UIRegistrationViewController?> { promised() }
}

public protocol UIRegistrationViewController: UIViewController {
    func show()
}
