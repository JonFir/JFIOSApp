import FactoryKit

extension Container {
    public var appNavigator: Factory<AppNavigator?> { promised() }
}

@MainActor
public protocol AppNavigator: AnyObject {
    func setup()
    func showSplash()
}
