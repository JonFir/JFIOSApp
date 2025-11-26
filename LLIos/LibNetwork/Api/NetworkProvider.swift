import Alamofire
import LibSwift
import FactoryKit

extension Container {
    public var networkProvider: Factory<NetworkProvider?> { promised().singleton }
}

public protocol NetworkProvider: Sendable {
    func subscribe(
        _ callback: @Sendable @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) async -> Void
    ) async -> AnySendableObject

    func request(
        _ convertible: any URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: any ParameterEncoding,
        headers: HTTPHeaders?,
        interceptor: (any RequestInterceptor)?,
        requestModifier: Session.RequestModifier?
    ) -> DataRequest
}

public extension NetworkProvider {
    func request(
        _ convertible: any URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: any ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        interceptor: (any RequestInterceptor)? = nil,
        requestModifier: Session.RequestModifier? = nil
    ) -> DataRequest {
        request(
            convertible,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            interceptor: interceptor,
            requestModifier: requestModifier
        )
    }
}
