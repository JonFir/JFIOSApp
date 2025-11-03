import SwiftUI

struct FirstModuleView<VM>: View where VM: FirstModuleViewModel {
    @Environment(VM.self) private var vm

    var body: some View {
        Text(vm.title)
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstModuleView<FirstModuleViewModelPrev>().environment(FirstModuleViewModelPrev())
    }
}








