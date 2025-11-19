import FactoryKit
import UIKit

extension Container {
    @MainActor
    public var mainViewController: Factory<UINavigationController> { self {
        @MainActor in UINavigationController()
    }.singleton }
}
