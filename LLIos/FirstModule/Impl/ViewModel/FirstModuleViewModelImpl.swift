import SwiftUI
import FactoryKit

extension Container {
    var firstModuleViewModel: Factory<FirstModuleViewModel> {
        self { FirstModuleViewModelImpl(title: "hello!") }
    }
}

@Observable
final class FirstModuleViewModelImpl: FirstModuleViewModel {
    
    let title: String

    init(title: String) {
        self.title = title
    }
}
