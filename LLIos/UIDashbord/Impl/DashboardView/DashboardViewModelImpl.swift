import SwiftUI
import FactoryKit

extension Container {
    @MainActor
    var dashboardViewModel: Factory<DashboardViewModel> {
        self { @MainActor in DashboardViewModelImpl() }
    }
}

@Observable
final class DashboardViewModelImpl: DashboardViewModel {
}

