import SwiftUI
import FactoryKit

extension Container {
    @MainActor
    var uiRegistrationViewModel: Factory<UIRegistrationViewModel> {
        self { @MainActor in UIRegistrationViewModelImpl() }
    }
}

@Observable
final class UIRegistrationViewModelImpl: UIRegistrationViewModel {
}

