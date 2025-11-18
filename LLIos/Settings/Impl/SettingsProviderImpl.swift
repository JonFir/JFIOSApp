import Foundation
import Settings
import LibSwift

public actor SettingsProviderImpl: SettingsProvider {
    public let initialSettings: Settings
    private var settings: Settings
    private let observers = Observers<Settings>()
    
    public init() {
        let appMetricaApiKey = (Bundle.main.object(forInfoDictionaryKey: "APP_METRICA_KEY") as? String) ?? ""

        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? ""

        let bundleID = Bundle.main.bundleIdentifier ?? ""

        initialSettings = Settings(
            appMetricaApiKey: appMetricaApiKey,
            appName: appName,
            bundleID: bundleID
        )
        settings = initialSettings
    }
    
    public func getSettings() -> Settings {
        return settings
    }
    
    public func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnySendableObject {
        await observers.subscribe(callback, settings)
    }
    
    public func setDeviceID(_ deviceID: String) async {
        settings = settings.with(deviceID: .set(deviceID))
        await observers.notify(settings)
    }
}
