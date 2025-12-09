import Foundation

public struct APIErrorResponse: Error, Decodable {
    public let status: Int?
    public let message: String?
    public let raw: String

    enum CodingKeys: CodingKey {
        case status
        case message
    }

    public init(status: Int? = nil, message: String? = nil, raw: String = "{}") {
        self.status = status
        self.message = message
        self.raw = raw
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Int.self, forKey: .status)
        message = try container.decode(String.self, forKey: .message)

        let fullJSONData = try JSONSerialization.data(
            withJSONObject: decoder.userInfo[.jsonRawObject] ?? [:],
            options: .prettyPrinted
        )
        self.raw = String(data: fullJSONData, encoding: .utf8) ?? "{}"
    }
}

private extension CodingUserInfoKey {
    static let jsonRawObject = CodingUserInfoKey(rawValue: "jsonRawObject")!
}
