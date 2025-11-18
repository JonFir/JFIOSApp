import AppMetricaCore
import Logger
import FactoryKit
import Settings

extension Container {
    public var appMetricaRegisterTask: Factory<AppMetricaRegisterTask?> { self { nil } }
}

public final class AppMetricaRegisterTask {
    @Injected(\.settingsProvider) private var settingsProvider: SettingsProvider!

    public func register() {
        let configuration = AppMetricaConfiguration(
            apiKey: settingsProvider.initialSettings.appMetricaApiKey
        )

        guard let configuration else { return }
        AppMetrica.activate(with: configuration)
        AppMetrica.requestStartupIdentifiers(for: [.deviceIDKey], on: .main) { [settingsProvider] identifiers, _ in
            guard let deviceID = identifiers?[.deviceIDKey] as? String else { return }
            Task.immediate {
                await settingsProvider?.update {
                    $0.deviceID = deviceID
                }
            }
        }
    }
}
