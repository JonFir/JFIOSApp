import UIKit
import SwiftUI
import FactoryKit

extension Container {
    public var uiLoginViewController: Factory<UILoginViewController?> { promised() }
}

public protocol UILoginViewController: UIViewController {}
