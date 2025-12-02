import FactoryKit
import UIKit
import LibUIKit

extension Container {
    public var uiSplashViewController: Factory<UISplashViewController?> { promised() }
}

public protocol UISplashViewController: BaseViewController {
    func replaceAppFlow()
}
