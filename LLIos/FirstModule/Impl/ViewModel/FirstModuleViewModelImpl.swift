import SwiftUI


@Observable
final class FirstModuleViewModelImpl: FirstModuleViewModel {
    
    let title: String

    init(title: String) {
        self.title = title
    }
}
