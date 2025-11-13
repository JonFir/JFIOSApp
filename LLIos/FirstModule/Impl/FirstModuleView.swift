import SwiftUI
import FactoryKit

struct FirstModuleView: View {
    @State var vm = Container.shared.firstModuleViewModel()

    var body: some View {
        Text(vm.title)
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container.shared.preview {
            $0.firstModuleViewModel.register { FirstModuleViewModelPrev() }
        }
        FirstModuleView()
    }
}
