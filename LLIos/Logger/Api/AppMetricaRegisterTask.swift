import FactoryKit

extension Container {
    public var appMetricaRegisterTask: Factory<AppMetricaRegisterTask?> { self { nil } }
}

public protocol AppMetricaRegisterTask {
    func register()
}
