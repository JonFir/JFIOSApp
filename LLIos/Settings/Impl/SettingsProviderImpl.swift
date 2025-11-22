import Foundation
import Settings
import LibSwift

public actor SettingsProviderImpl: SettingsProvider {
    public let initialSettings: Settings
    private(set) public var settings: Settings
    private let observers = Observers<Settings>()

    public init() {
        let appMetricaApiKey = (Bundle.main.object(forInfoDictionaryKey: "APP_METRICA_KEY") as? String) ?? ""

        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? ""

        let bundleID = Bundle.main.bundleIdentifier ?? ""
        
        let applicationSupportDirectory = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first
        
        let baseDirectory: URL
        if let applicationSupportDirectory {
            baseDirectory = applicationSupportDirectory
        } else {
            baseDirectory = FileManager.default.temporaryDirectory
        }
        
        let persistenceDirectory = baseDirectory
            .appendingPathComponent("PersistenceFiles", isDirectory: true)

        initialSettings = Settings(
            appMetricaApiKey: appMetricaApiKey,
            appName: appName,
            bundleID: bundleID,
            persistenceDirectory: persistenceDirectory
        )
        settings = initialSettings
    }
    
    public func getSettings() -> Settings {
        return settings
    }
    
    public func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnySendableObject {
        await observers.subscribe(callback, settings)
    }

    public func update(_ updater: @Sendable (inout Settings) -> Void) async {
        updater(&settings)
        await observers.notify(settings)
    }
}
