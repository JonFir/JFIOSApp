import UIKit

#if DEBUG
public final class UIRegistrationViewControllerMock: UIViewController, UIRegistrationViewController {
    public var showCallCount = 0

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        showCallCount += 1
    }
}
#endif

