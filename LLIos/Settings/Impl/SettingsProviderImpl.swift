import Foundation
import Settings
import LibSwift

public actor SettingsProviderImpl: SettingsProvider {
    public let initialSettings: Settings
    private(set) public var settings: Settings
    private let observers = Observers<Settings>()

    public init() {
        let appMetricaApiKey = Bundle.string("APP_METRICA_KEY") ?? ""
        let appName = Bundle.string("CFBundleDisplayName") ?? Bundle.string("CFBundleName") ?? ""
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        
        let baseDirectory: URL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first ?? FileManager.default.temporaryDirectory
        let persistenceDirectory = baseDirectory
            .appendingPathComponent("PersistenceFiles", isDirectory: true)

        initialSettings = Settings(
            appMetricaApiKey: appMetricaApiKey,
            appName: appName,
            bundleID: bundleID,
            persistenceDirectory: persistenceDirectory,
            apiHost: URL(string: "http://127.0.0.1:8090/")!
        )
        settings = initialSettings
    }
    
    public func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnySendableObject {
        await observers.subscribe(callback, settings)
    }

    public func update(_ updater: @Sendable (inout Settings) -> Void) async {
        updater(&settings)
        await observers.notify(settings)
    }
}

private extension Bundle {
    static func string(_ key: String) -> String? {
        self.main.object(forInfoDictionaryKey: key) as? String
    }
}
