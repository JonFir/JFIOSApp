import UIKit
import SwiftUI

public final class BaseViewController: UIHostingController<AnyView> {

    public init(view: any View) {
        let view = AnyView(view)
        super.init(rootView: view)
    }

    @available(*, deprecated, message: "use init(view:) instead")
    public override init(rootView: AnyView) {
        super.init(rootView: rootView)
    }

    @available(*, deprecated, message: "use init(view:) instead")
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
