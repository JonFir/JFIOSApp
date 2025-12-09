@preconcurrency import UIKit

#if DEBUG
public final class UIDashboardViewControllerMock: UIViewController, UIDashboardViewController {
    public var replaceAppFlowCallCount = 0

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func replaceAppFlow() {
        replaceAppFlowCallCount += 1
    }
}
#endif

