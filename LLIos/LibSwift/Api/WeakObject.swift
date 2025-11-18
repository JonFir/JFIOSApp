/// A generic wrapper that holds a weak reference to an object.
///
/// This class is useful for storing references to objects without preventing their deallocation,
/// helping to avoid retain cycles and memory leaks. When the referenced object is deallocated,
/// the `value` property automatically becomes `nil`.
///
/// Example:
/// ```swift
/// class MyClass {
///     var name: String
///     init(name: String) { self.name = name }
/// }
///
/// var obj: MyClass? = MyClass(name: "Test")
/// let weakRef = WeakObject(obj!)
/// print(weakRef.value?.name) // Prints: "Optional("Test")"
///
/// obj = nil
/// print(weakRef.value) // Prints: "nil"
/// ```
public final class WeakObject<T: AnyObject> {
    private(set) public weak var value: T?

    /// Creates a weak reference wrapper for the given object.
    ///
    /// - Parameter value: The object to hold a weak reference to
    public init(_ value: T) {
        self.value = value
    }
}
