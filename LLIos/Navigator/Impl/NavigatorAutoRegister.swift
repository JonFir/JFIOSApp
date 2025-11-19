import FactoryKit
import Navigator

public class NavigatorAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.appNavigator.register { @MainActor in
            AppNavigatorImpl()
        }
    }
}
