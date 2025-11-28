import FactoryKit
import UIKit
import Navigator
import LibUIKit

extension Container {
    public var uiSplashViewController: Factory<UISplashViewController?> { promised() }
}

public protocol UISplashViewController: BaseViewController {
    func replaceAppFlow()
}
