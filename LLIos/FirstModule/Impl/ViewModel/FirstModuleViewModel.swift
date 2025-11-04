import SwiftUI

protocol FirstModuleViewModel: Observable, AnyObject {
    var title: String { get }
}

struct FirstModuleViewModelKey: EnvironmentKey {
    static let defaultValue: any FirstModuleViewModel = FirstModuleViewModelPrev()
}

extension EnvironmentValues {
    var firstModuleViewModel: any FirstModuleViewModel {
        get { self[FirstModuleViewModelKey.self] }
        set { self[FirstModuleViewModelKey.self] = newValue }
    }
}
