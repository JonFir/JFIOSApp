import Alamofire
import Foundation

public enum MockInterceptorError: Error {
    case noMockResponse
}

public final class MockInterceptor: RequestInterceptor {

    private let responses: [MockResponse]

    public init(responses: [MockResponse]) {
        self.responses = responses
    }

    public func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void
    ) {
        let response = responses.first {
            $0.url.lowercased() == urlRequest.url?.absoluteString.lowercased() && $0.method == urlRequest.httpMethod
        }

        guard let response else {
            completion(.failure(MockInterceptorError.noMockResponse))
            return
        }

        let url = URL(string: response.url)!
        var request = URLRequest(url: url)
        request.httpMethod = response.method

        for header in response.headers ?? [:] {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        request.setValue("\(response.statusCode)", forHTTPHeaderField: MockResponse.statusCodeKey)
        request.httpBody = response.body


        if let delay = response.delay {
            Task {
                try await Task.sleep(for: delay)
                completion(.success(request))
            }
        } else {
            completion(.success(request))
        }
    }

}
