import Foundation
import LibSwift

#if DEBUG
public actor AccountStorageMock: AccountStorage {
    public private(set) var saveCalls: [Account] = []
    public private(set) var loadCallCount: Int = 0
    public private(set) var deleteCallCount: Int = 0
    public private(set) var subscribeCallCount: Int = 0
    
    public var loadResult: Account?
    public var subscribeResult: AnySendableObject?
    
    public init() {}
    
    public func save(account: Account) async {
        saveCalls.append(account)
    }
    
    public func load() async -> Account? {
        loadCallCount += 1
        return loadResult
    }
    
    public func delete() async {
        deleteCallCount += 1
    }
    
    public func subscribe(_ callback: @escaping @Sendable (Account?) async -> Void) async -> AnySendableObject {
        subscribeCallCount += 1
        if let result = subscribeResult {
            return result
        }
        return SimpleToken()
    }
}

private final class SimpleToken: @unchecked Sendable {
    init() {}
}
#endif

