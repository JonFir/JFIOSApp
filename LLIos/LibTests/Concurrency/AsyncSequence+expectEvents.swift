
public func expectEvents<T: AsyncSequence>(
    from sequence: T,
    max count: Int,
    timeout seconds: Int64,
    isolation: isolated (any Actor)? = #isolation
) async -> [T.Element] where T: Sendable, T.Element: Sendable {
    var result: [T.Element] = []

    let collectTask = Task {
        for try await value in sequence {
            result.append(value)
            if result.count >= count {
                break
            }
        }
        return result
    }

    let timeoutTask = Task {
        try? await Task.sleep(for: Duration(secondsComponent: seconds, attosecondsComponent: 0))
        collectTask.cancel()
    }

    let values = try! await collectTask.value
    timeoutTask.cancel()
    return values
}
