import UILogin
import SwiftUI
import LibUIKit
import Logger
import Navigator
import FactoryKit

final class UILoginViewControllerImpl: BaseViewController, UILoginViewController {
    @LazyInjected(\.appNavigator) var navigator
    @LazyInjected(\.logger) var logger

    func replaceAppFlow() {
        guard let vc = Container.shared.uiLoginViewController() else {
            logger?.critical("can't show loign view controller", category: .ui, module: "UILogin")
            return
        }
        navigator?.replace([vc], animated: false)
    }
}
