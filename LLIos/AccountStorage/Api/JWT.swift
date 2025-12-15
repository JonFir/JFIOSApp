import Foundation

public enum JWTDecodeError: Error {
    case invalidToken
    case invalidBase64
}

/// Decodes the payload from a JWT token string.
///
/// Extracts and decodes the base64-encoded payload segment from a JWT token.
///
/// - Throws: `JWTDecodeError`
public func decodeJWTPayload(
    _ token: String,
    decoder: JSONDecoder = JSONDecoder()
) throws -> PocketBaseJWT {
    let segments = token.split(separator: ".")
    guard segments.count == 3 else {
        throw JWTDecodeError.invalidToken
    }

    var base64 = segments[1]
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

    while base64.count % 4 != 0 {
        base64.append("=")
    }

    guard let data = Data(base64Encoded: base64) else {
        throw JWTDecodeError.invalidBase64
    }

    return try decoder.decode(PocketBaseJWT.self, from: data)
}

public struct PocketBaseJWT: Decodable {
    public let collectionId: String?
    public let exp: TimeInterval?
    public let id: String?
    public let refreshable: Bool?
    public let type: String?
}
