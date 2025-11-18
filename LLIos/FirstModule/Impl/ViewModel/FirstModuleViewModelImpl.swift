import SwiftUI
import FactoryKit

extension Container {
    @MainActor
    var firstModuleViewModel: Factory<FirstModuleViewModel> {
        self { @MainActor in FirstModuleViewModelImpl(title: "hello!") }.shared
    }
}

@Observable
final class FirstModuleViewModelImpl: FirstModuleViewModel {
    
    let title: String

    init(title: String) {
        self.title = title
    }
}
