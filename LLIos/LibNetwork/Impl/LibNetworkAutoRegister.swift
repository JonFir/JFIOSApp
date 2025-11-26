import FactoryKit
import LibNetwork
import UIKit

public class LoggerAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.networkProvider.register {
            NetworkProviderImpl()
        }
    }
}
