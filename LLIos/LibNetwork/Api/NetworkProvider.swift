import Alamofire
import LibSwift
import FactoryKit
import Foundation

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias Parameters = Alamofire.Parameters

extension Container {
    public var networkProvider: Factory<NetworkProvider?> { promised().singleton }
}

public protocol NetworkProvider: Actor {
    func subscribe(
        _ callback: @Sendable @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) async -> Void
    ) async -> AnySendableObject

    func codable<T>(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> T where T: Sendable, T: Decodable

    func empty(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws

    func string(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> String

    func data(
        path: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        anonimous: Bool,
    ) async throws -> Data

}

public extension NetworkProvider {
    @_disfavoredOverload
    func codable<T>(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders = [],
        anonimous: Bool = false,
    ) async throws -> T where T: Sendable, T: Decodable {
        try await codable(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        )
    }

    @_disfavoredOverload
    func empty(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders = [],
        anonimous: Bool = false,
    ) async throws {
        try await empty(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        )
    }

    @_disfavoredOverload
    func string(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders = [],
        anonimous: Bool = false,
    ) async throws -> String {
        try await string(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        )
    }

    @_disfavoredOverload
    func data(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders = [],
        anonimous: Bool = false,
    ) async throws -> Data {
        try await data(
            path: path,
            method: method,
            parameters: parameters,
            headers: headers,
            anonimous: anonimous,
        )
    }
}
