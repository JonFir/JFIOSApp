import Alamofire
import Foundation
import LibSwift

#if DEBUG
public actor NetworkProviderMock: NetworkProvider {
    public typealias OnRequest = @Sendable (String, HTTPMethod, Parameters?, HTTPHeaders) async throws -> Sendable

    private let observers = Observers<NetworkReachabilityManager.NetworkReachabilityStatus>()
    
    public private(set) var subscribeCallCount: Int = 0
    
    public var onRequest: OnRequest!
    public var requestCallResults: [(String, HTTPMethod, Parameters?, HTTPHeaders)] = []
    public var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    
    public init(onRequest: OnRequest? = nil) {
        self.onRequest = onRequest
    }

    public func update(onRequest: @escaping OnRequest) {
        self.onRequest = onRequest
    }

    public func subscribe(
        _ callback: @Sendable @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) async -> Void
    ) async -> AnySendableObject {
        subscribeCallCount += 1
        return await observers.subscribe(callback, reachabilityStatus)
    }
    
    public func codable<T>(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> T where T: Sendable, T: Decodable {
        requestCallResults.append((path, method, parameters, headers))
        return try await onRequest(path, method, parameters, headers) as! T
    }
    
    public func empty(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws {
        requestCallResults.append((path, method, parameters, headers))
        _ = try await onRequest(path, method, parameters, headers)
    }
    
    public func string(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> String {
        requestCallResults.append((path, method, parameters, headers))
        return try await onRequest(path, method, parameters, headers) as! String
    }
    
    public func data(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> Data {
        requestCallResults.append((path, method, parameters, headers))
        return try await onRequest(path, method, parameters, headers) as! Data
    }
    
    public func notifyReachability(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) async {
        reachabilityStatus = status
        await observers.notify(status)
    }
    
    public func reset() {
        subscribeCallCount = 0
        reachabilityStatus = .unknown
    }
}
#endif

