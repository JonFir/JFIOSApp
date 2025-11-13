import UIKit
import SwiftUI
import FactoryKit

extension Container {
    public var firstModuleViewController: Factory<FirstModuleViewController?> { promised() }
}

public protocol FirstModuleViewController: UIViewController {}
