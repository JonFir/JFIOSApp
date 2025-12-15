import Foundation
import LibSwift

#if DEBUG
public actor SettingsProviderMock: SettingsProvider {
    
    public nonisolated let initialSettings: Settings
    public private(set) var settings: Settings
    private let observers = Observers<Settings>()
    
    public private(set) var subscribeCallCount: Int = 0
    public private(set) var updateCallCount: Int = 0
    
    /// Creates a mock with default settings.
    public init() {
        let defaultSettings = Settings(
            appMetricaApiKey: "mock-appmetrica-key",
            appName: "MockApp",
            bundleID: "com.mock.app",
            persistenceDirectory: URL(fileURLWithPath: "/tmp/mock-persistence"),
            deviceID: nil,
            apiHost: URL(string: "http://127.0.0.1:8090/")!
        )
        self.initialSettings = defaultSettings
        self.settings = defaultSettings
    }
    
    /// Creates a mock with custom initial settings.
    ///
    /// - Parameter settings: Custom settings to use as initial and current settings
    public init(settings: Settings) {
        self.initialSettings = settings
        self.settings = settings
    }
    
    public func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnySendableObject {
        subscribeCallCount += 1
        return await observers.subscribe(callback, settings)
    }
    
    public func update(_ updater: @Sendable (inout Settings) -> Void) async {
        updateCallCount += 1
        updater(&settings)
        await observers.notify(settings)
    }
    
    /// Resets settings to initial state and clears call counters.
    public func reset() {
        settings = initialSettings
        subscribeCallCount = 0
        updateCallCount = 0
    }
}
#endif
