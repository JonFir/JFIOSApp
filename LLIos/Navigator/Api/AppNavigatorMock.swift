import UIKit

#if DEBUG
@MainActor
public final class AppNavigatorMock: AppNavigator {
    public private(set) var pushCalls: [(viewController: UIViewController, animated: Bool)] = []
    public private(set) var replaceCalls: [(viewControllers: [UIViewController], animated: Bool)] = []
    public private(set) var setupCallCount: Int = 0
    
    public init() {}
    
    public func push(_ viewController: UIViewController, animated: Bool) {
        pushCalls.append((viewController: viewController, animated: animated))
    }
    
    public func replace(_ viewControllers: [UIViewController], animated: Bool) {
        replaceCalls.append((viewControllers: viewControllers, animated: animated))
    }
    
    public func setup() {
        setupCallCount += 1
    }
}
#endif

