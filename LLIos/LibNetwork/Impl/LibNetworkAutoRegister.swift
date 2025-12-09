import FactoryKit
import LibNetwork
import UIKit
import Alamofire

public class LibNetworkAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.networkProvider.register {
            NetworkProviderImpl()
        }
    }
}
