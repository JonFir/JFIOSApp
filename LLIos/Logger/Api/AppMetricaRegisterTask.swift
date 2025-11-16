import FactoryKit

extension Container {
    public var appMetricaRegisterTask: Factory<AppMetricaRegisterTask?> { promised() }
}

public protocol AppMetricaRegisterTask {
    func register()
}
