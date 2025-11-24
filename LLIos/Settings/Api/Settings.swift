import Foundation

/// Contains application settings and configuration parameters.
///
/// This structure holds essential app configuration such as analytics keys,
/// app metadata, and bundle information.
public struct Settings: Sendable {
    public let appMetricaApiKey: String
    public let appName: String
    public let bundleID: String
    public let persistenceDirectory: URL
    public let apiHost: URL

    /// AppMetrica device identifier
    public var deviceID: String?
    
    public init(
        appMetricaApiKey: String,
        appName: String,
        bundleID: String,
        persistenceDirectory: URL,
        deviceID: String? = nil,
        apiHost: URL
    ) {
        self.appMetricaApiKey = appMetricaApiKey
        self.appName = appName
        self.bundleID = bundleID
        self.persistenceDirectory = persistenceDirectory
        self.deviceID = deviceID
        self.apiHost = apiHost
    }
}
