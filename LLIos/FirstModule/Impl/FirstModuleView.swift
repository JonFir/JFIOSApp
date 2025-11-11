import SwiftUI

struct FirstModuleView: View {
    @Environment(\.firstModuleViewModel) private var vm

    var body: some View {
        Text(vm.title)
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstModuleView()
            .environment(\.firstModuleViewModel, FirstModuleViewModelPrev())
    }
}
