import SwiftUI
import FactoryKit
import UIComponents
import Resources
import Logger

struct UIRegistrationView: View {
    @State
    private var vm = resolve(\.uiRegistrationViewModel)
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    Container.shared.preview {
        $0.uiRegistrationViewModel.register { @MainActor in UIRegistrationViewModelPrev() }
    }
    UIRegistrationView()
}

