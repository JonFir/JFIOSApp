import Foundation

/// Contains application settings and configuration parameters.
///
/// This structure holds essential app configuration such as analytics keys,
/// app metadata, and bundle information.
public struct Settings: Sendable {
    public let appMetricaApiKey: String
    public let appName: String
    public let bundleID: String
    
    /// AppMetrica device identifier
    public var deviceID: String?
    
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
}
