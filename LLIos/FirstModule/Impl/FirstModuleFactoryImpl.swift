import FirstModule
import SwiftUI

public class FirstModuleFactoryImpl: FirstModuleFactory {

    public init() {}

    public func makeFirstScreen(title: String) -> UIViewController {
        UIHostingController(
            rootView: FirstModuleView<FirstModuleViewModelImpl>().environment(FirstModuleViewModelImpl(title: title))
        )
    }

}
