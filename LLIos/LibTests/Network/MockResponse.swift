import Foundation

/// Represents a mock HTTP response that can be used to intercept and mock network requests.
///
/// MockResponse contains all necessary information to simulate an HTTP response:
/// URL pattern, HTTP method, status code, headers, and response body data.
///
/// Example:
/// ```swift
/// let mockResponse = MockResponse(
///     url: "https://api.example.com/users",
///     method: .get,
///     statusCode: 200,
///     headers: ["Content-Type": "application/json"],
///     body: """
///     {
///         "id": 1,
///         "name": "John Doe"
///     }
///     """.data(using: .utf8)
/// )
/// MockUrlProtocol.addResponse(mockResponse)
/// ```
public struct MockResponse: Sendable {
    static let statusCodeKey = "X-MockResponse-StatusCode"
    /// The URL pattern to match against incoming requests.
    public let url: String

    /// The HTTP method that this mock response should handle.
    public let method: String

    /// The HTTP status code to return in the response.
    public let statusCode: Int

    /// HTTP headers to include in the response.
    public let headers: [String: String]?

    /// The response body data.
    public let body: Data?

    public let delay: Duration?

    public init(
        url: String,
        method: String = "get",
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        delay: Duration? = nil,
        body: Data? = nil
    ) {
        self.url = url
        self.method = method
        self.statusCode = statusCode
        self.headers = headers
        self.delay = delay
        self.body = body
    }

    public init<T: Codable>(
        url: String,
        method: String = "get",
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        delay: Duration? = nil,
        codable: T
    ) {
        self.url = url
        self.method = method
        self.statusCode = statusCode

        var finalHeaders = headers ?? [:]
        if finalHeaders["Content-Type"] == nil {
            finalHeaders["Content-Type"] = "application/json"
        }
        self.headers = finalHeaders
        self.delay = delay

        let encoder = JSONEncoder()
        self.body = try? encoder.encode(codable)
    }

    public init(
        url: String,
        method: String = "get",
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        delay: Duration? = nil,
        jsonString: String
    ) {
        self.url = url
        self.method = method
        self.statusCode = statusCode

        var finalHeaders = headers ?? [:]
        if finalHeaders["Content-Type"] == nil {
            finalHeaders["Content-Type"] = "application/json"
        }
        self.headers = finalHeaders
        self.delay = delay

        self.body = jsonString.data(using: .utf8)
    }
}
