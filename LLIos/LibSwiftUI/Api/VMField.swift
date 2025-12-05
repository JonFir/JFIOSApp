public struct VMField<T> where T: Sendable {
    public var text: String
    private(set) public var value: VMFieldValue<T>
    let transform: @Sendable (String) -> VMFieldValue<T>

    public init(
        _ text: String,
        transform: @Sendable @escaping (String) -> VMFieldValue<T>
    ) {
        self.text = text
        self.value = .empty
        self.transform = transform
    }

    public mutating func updateValue() {
        value = transform(text)
    }
    
}

public enum VMFieldValue<T>: Sendable where T: Sendable {
    case value(T)
    case error(String)
    case empty

    public var value: T? {
        guard case .value(let value) = self else { return nil }
        return value
    }

    public var error: String? {
        guard case .error(let error) = self else { return nil }
        return error
    }

    public var isEmpty: Bool {
        guard case .empty = self else { return false }
        return true
    }
}
