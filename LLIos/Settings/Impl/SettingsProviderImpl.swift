import Foundation
import Settings

private struct WeakSubscriber {
    weak var subscriber: SettingsSubscriber?
}

public actor SettingsProviderImpl: SettingsProvider {
    public let initialSettings: Settings
    private var settings: Settings
    private var subscribers: [WeakSubscriber] = []
    
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
    
    public func getSettings() async -> Settings {
        return settings
    }
    
    public func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnyObject & Sendable {
        let subscriber = SettingsSubscriber(callback: callback)
        subscribers.append(WeakSubscriber(subscriber: subscriber))
        
        await callback(settings)

        return subscriber
    }
    
    public func setDeviceID(_ deviceID: String) async {
        settings = settings.with(deviceID: .set(deviceID))
        await notifySubscribers()
    }

    private func notifySubscribers() async {
        subscribers.removeAll { $0.subscriber == nil }
        
        for weakSubscriber in subscribers {
            await weakSubscriber.subscriber?.callback(settings)
        }
    }
}
