public struct CommonError: Error, CustomStringConvertible {
    public let message: String
    public let code: Int?
    public let underlyingError: Error?
    public var description: String {
        var components: [String] = []

        if let code {
            components.append("Code: \(code)")
        }

        components.append("Message: \(message)")

        if let underlyingError {
            components.append("Underlying error: \(underlyingError)")
        }

        return components.joined(separator: ", ")
    }

    public init(
        _ message: String,
        _ code: Int? = nil,
        _ underlyingError: Error? = nil
    ) {
        self.message = message
        self.code = code
        self.underlyingError = underlyingError
    }
}
