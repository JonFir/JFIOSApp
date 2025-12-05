import Foundation
import Testing
import Alamofire

/// A URLProtocol subclass that intercepts network requests and returns mock responses.
///
/// MockUrlProtocol maintains a static array of MockResponse configurations and matches
/// incoming requests against them. When a match is found, it returns the configured
/// mock response instead of making a real network request.
///
/// To use this protocol, you need to:
/// 1. Register it with URLSession configuration
/// 2. Add mock responses using the addResponse method
/// 3. Make requests through the configured session
///
/// Example:
/// ```swift
/// // Add mock response
/// MockUrlProtocol.addResponse(
///     MockResponse(
///         url: "https://api.example.com/users",
///         method: .get,
///         statusCode: 200,
///         body: userData
///     )
/// )
///
/// // Configure URLSession to use mock protocol
/// let config = URLSessionConfiguration.default
/// config.protocolClasses = [MockUrlProtocol.self]
/// let session = Session(configuration: config)
/// ```
public final class MockUrlProtocol: URLProtocol {
    
    public override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    public override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        let statusCode = request.value(forHTTPHeaderField: MockResponse.statusCodeKey).flatMap { Int($0) } ?? 200
        guard let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: "HTTP/2",
            headerFields: request.allHTTPHeaderFields
        ) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let body = request.readBodyData() {
            client?.urlProtocol(self, didLoad: body)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    public override func stopLoading() {}
}


extension URLRequest {
    func readBodyData() -> Data? {
        if let httpBody = self.httpBody {
            return httpBody
        }

        guard let stream = self.httpBodyStream else { return nil }

        stream.open()
        defer { stream.close() }

        var buffer = [UInt8](repeating: 0, count: 1024)
        let data = NSMutableData()

        while stream.hasBytesAvailable {
            let count = stream.read(&buffer, maxLength: buffer.count)
            if count > 0 { data.append(buffer, length: count) }
            else { break }
        }

        return data as Data
    }
}
