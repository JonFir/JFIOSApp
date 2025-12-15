/// A wrapper around an async callback function that observes value changes.
///
/// This class serves as a subscription token and holds the callback that will be invoked
/// when new values are emitted.
private final class Observer<T>: Sendable where T: Sendable {
    let callback: @Sendable (T) async -> Void

    init(callback: @escaping @Sendable (T) async -> Void) {
        self.callback = callback
    }
}

/// A manager for handling multiple observers using weak references.
///
/// This class maintains a collection of observers and notifies them when values change.
/// Observers are held weakly to prevent memory leaks - when an observer token is deallocated,
/// it's automatically removed from the collection on the next notification.
///
/// Example:
/// ```swift
/// class Counter {
///     private let observers = Observers<Int>()
///     private var count = 0
///
///     func subscribe(_ callback: @escaping @Sendable (Int) async -> Void) async -> AnySendableObject {
///         await observers.subscribe(callback, count)
///     }
///
///     func increment() async {
///         count += 1
///         await observers.notify(count)
///     }
/// }
///
/// // Usage
/// let counter = Counter()
/// let token = await counter.subscribe { value in
///     print("Counter: \(value)")
/// }
/// // Keep token alive to maintain subscription
/// await counter.increment() // Prints: "Counter: 1"
/// ```
public final class Observers<T> where T: Sendable {

    private var observers: [WeakObject<Observer<T>>] = []

    public init() {}

    /// Subscribes a callback to receive updates and immediately invokes it with the current value.
    ///
    /// The callback is stored with a weak reference through the returned token. When the token
    /// is deallocated, the subscription is automatically removed.
    ///
    /// - Parameters:
    ///   - callback: An async function to be called when values change
    ///   - currentValue: The initial value to be immediately sent to the callback
    /// - Returns: A subscription token that must be retained to keep the subscription alive
    ///
    /// Example:
    /// ```swift
    /// let observers = Observers<String>()
    /// let token = await observers.subscribe({ text in
    ///     print("Received: \(text)")
    /// }, "Initial")
    /// // Prints: "Received: Initial"
    /// ```
    public func subscribe(_ callback: @escaping @Sendable (T) async -> Void, _ currentValue: T) async -> AnySendableObject {
        let observer = Observer(callback: callback)
        observers.append(WeakObject(observer))
        await callback(currentValue)
        return observer
    }

    /// Notifies all active observers with a new value.
    ///
    /// This method cleans up deallocated observers before notifying, then sends the value
    /// to all remaining active subscribers sequentially.
    ///
    /// - Parameter value: The value to send to all observers
    ///
    /// Example:
    /// ```swift
    /// let observers = Observers<Int>()
    /// let token = await observers.subscribe({ count in
    ///     print("Count: \(count)")
    /// }, 0)
    /// await observers.notify(5) // Prints: "Count: 5"
    /// ```
    public func notify(_ value: T) async {
        observers.removeAll { $0.value == nil }

        for observer in observers {
            await observer.value?.callback(value)
        }
    }
}
