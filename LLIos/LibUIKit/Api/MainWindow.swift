import FactoryKit
import UIKit

extension Container {
    @MainActor
    public var mainWindow: Factory<UIWindow?> { promised() }
}
