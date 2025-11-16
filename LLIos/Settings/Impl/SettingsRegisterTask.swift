import FactoryKit

extension Container {
    public var settingsRegisterTask: Factory<SettingsRegisterTask> { self { SettingsRegisterTask() } }
}

public final class SettingsRegisterTask {
    public func register() {
        Container.shared.settingsProvider.register {
            return SettingsProviderImpl()
        }
    }
}
