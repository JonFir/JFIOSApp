import AppMetricaCore
import Logger
import FactoryKit
import Settings

extension Container {
    public var appMetricaRegisterTask: Factory<AppMetricaRegisterTask?> { promised() }
}

public final class AppMetricaRegisterTask {
    @Injected(\.settingsProvider) private var settingsProvider: SettingsProvider!

    public func register() {
        let configuration = AppMetricaConfiguration(
            apiKey: settingsProvider.initialSettings.appMetricaApiKey
        )

        guard let configuration else { return }
        AppMetrica.activate(with: configuration)
    }
}
