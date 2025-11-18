/// Represents a change to an optional field when copying a struct.
///
/// Provides explicit control over optional fields with three distinct operations:
/// keep the existing value, set a new value, or clear the field.
///
/// Example usage:
/// ```swift
/// struct User {
///     let name: String
///     let avatar: String?
///     
///     func with(name: String? = nil, avatar: OptionalChange<String> = .keep) -> User {
///         User(
///             name: name ?? self.name,
///             avatar: avatar ?? self.avatar
///         )
///     }
/// }
///
/// let user = User(name: "Alice", avatar: "photo.jpg")
/// let renamed = user.with(name: "Bob")  // avatar stays "photo.jpg"
/// let withAvatar = user.with(avatar: .set("new.jpg"))  // set new avatar
/// let noAvatar = user.with(avatar: .clear)  // clear avatar (set to nil)
/// ```
public enum OptionalChange<T>: Sendable where T: Sendable {
    case keep
    case set(T)
    case clear
    
    /// Returns the resulting value based on the change type.
    ///
    /// - Parameter current: Current value to use if change is .keep
    /// - Returns: Current value for .keep, new value for .set, or nil for .clear
    func value(_ current: T?) -> T? {
        switch self {
        case .keep:
            return current
        case .set(let value):
            return value
        case .clear:
            return nil
        }
    }
}

public func ?? <T>(change: OptionalChange<T>, current: T?) -> T? {
    change.value(current)
}
