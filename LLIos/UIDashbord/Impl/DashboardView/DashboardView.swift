import SwiftUI
import FactoryKit
import UIComponents
import Resources
import Logger

struct DashboardView: View {
    @State
    private var vm = resolve(\.dashboardViewModel)
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    Container.shared.preview {
        $0.dashboardViewModel.register { @MainActor in DashboardViewModelPrev() }
    }
    DashboardView()
}

