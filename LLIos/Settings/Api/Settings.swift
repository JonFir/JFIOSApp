import Foundation
import LibSwift

/// Contains application settings and configuration parameters.
///
/// This structure holds essential app configuration such as analytics keys,
/// app metadata, and bundle information.
public struct Settings: Sendable {
    public let appMetricaApiKey: String
    public let appName: String
    public let bundleID: String
    
    /// AppMetrica device identifier
    public let deviceID: String?
    
    public init(
        appMetricaApiKey: String,
        appName: String,
        bundleID: String,
        deviceID: String? = nil
    ) {
        self.appMetricaApiKey = appMetricaApiKey
        self.appName = appName
        self.bundleID = bundleID
        self.deviceID = deviceID
    }
    
    public func with(
        appMetricaApiKey: String? = nil,
        appName: String? = nil,
        bundleID: String? = nil,
        deviceID: OptionalChange<String> = .keep
    ) -> Settings {
        Settings(
            appMetricaApiKey: appMetricaApiKey ?? self.appMetricaApiKey,
            appName: appName ?? self.appName,
            bundleID: bundleID ?? self.bundleID,
            deviceID: deviceID ?? self.deviceID
        )
    }
}
