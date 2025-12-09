import UIKit
import SwiftUI
import FactoryKit

extension Container {
    public var uiDashboardViewController: Factory<UIDashboardViewController?> { promised() }
}

public protocol UIDashboardViewController: UIViewController {
    func replaceAppFlow()
}

