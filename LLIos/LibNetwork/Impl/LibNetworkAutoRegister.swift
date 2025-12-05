import FactoryKit
import LibNetwork
import UIKit
import Alamofire

public class LoggerAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.networkSession.register {
            Session()
        }
    }
}
