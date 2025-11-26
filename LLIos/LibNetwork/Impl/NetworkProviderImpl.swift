import Alamofire
import LibSwift
import LibNetwork

actor NetworkProviderImpl: NetworkProvider {

    let session = Session()

    let reachabilityManager = NetworkReachabilityManager()
    let reachabilityObservers = Observers<NetworkReachabilityManager.NetworkReachabilityStatus>()
    var listenerTask: Task<Void, Never>?

    func startListenReachability() async {
        let stream = AsyncStream<NetworkReachabilityManager.NetworkReachabilityStatus> { [reachabilityManager] continuation in
            reachabilityManager?.startListening(onQueue: .global(qos: .userInitiated)) { status in
                continuation.yield(status)
            }
            continuation.onTermination = { @Sendable _ in
                reachabilityManager?.stopListening()
                continuation.finish()
            }
        }

        listenerTask = Task {
            for await status in stream {
                await self.reachabilityObservers.notify(status)
            }
        }
    }

    func stopListenReachability() {
        listenerTask?.cancel()
    }

    func subscribe(
        _ callback: @Sendable @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) async -> Void
    ) async -> AnySendableObject {
        await reachabilityObservers.subscribe(callback, reachabilityManager?.status ?? .unknown)
    }

    nonisolated func request(
        _ convertible: any URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: any ParameterEncoding,
        headers: HTTPHeaders?,
        interceptor: (any RequestInterceptor)?,
        requestModifier: Session.RequestModifier?
    ) -> DataRequest {
        return session.request(
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
