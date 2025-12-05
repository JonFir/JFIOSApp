import Foundation
import Alamofire
import FactoryKit
import LibNetwork

public extension Container {

    func setupMocks(_ responses: [MockResponse]) {
        let interceptor = MockInterceptor(responses: responses)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockUrlProtocol.self]
        self.networkSession.register {
            Session(
                configuration: configuration,
                interceptor: interceptor,
            )
        }
    }
    
}

