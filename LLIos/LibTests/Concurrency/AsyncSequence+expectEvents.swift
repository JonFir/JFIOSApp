
public func expectEvents<T: AsyncSequence>(
    from sequence: T,
    max count: Int,
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

    let values = try! await collectTask.value
    return values
}
