import Swinject
import FirstModule
import SwiftUI

public class FirstModuleAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(FirstModuleViewController.self) { r in
            let vm = FirstModuleViewModelImpl(title: "привет!")
            let view = FirstModuleView()
                .environment(\.firstModuleViewModel, vm)
            let anyView = AnyView(erasing: view)
            return FirstModuleViewControllerImpl(rootView: anyView)
        }
    }
}
