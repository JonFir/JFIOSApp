import Foundation
import FactoryKit
import LibSwift

extension Container {
    public var settingsProvider: Factory<SettingsProvider?> { promised().singleton }
}

/// Provides access to application settings and configuration.
///
/// SettingsProvider is an actor that manages application settings in memory,
/// supports multiple subscribers for settings changes, and automatically
/// configures initial settings from environment and bundle information.
///
/// Example usage:
/// ```swift
/// let provider = Container.shared.settingsProvider()
///
/// await provider.configure()
/// let settings = await provider.getSettings()
///
/// await provider.subscribe { updatedSettings in
///     print("Settings updated: \(updatedSettings)")
/// }
///
/// await provider.setDeviceID("device-123")
/// ```
public protocol SettingsProvider: Actor {
    nonisolated var initialSettings: Settings { get }
    /// Returns current application settings.
    ///
    /// - Returns: Current Settings instance
    func getSettings() -> Settings
    
    /// Subscribes to settings changes with automatic cleanup when token is deallocated.
    ///
    /// Multiple subscribers are supported. Callbacks are invoked whenever settings change.
    /// Keep the returned token alive as long as you want to receive updates.
    ///
    /// - Parameter callback: Closure called when settings are updated
    /// - Returns: Subscription token that must be retained to keep subscription active
    func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnySendableObject

    /// Updates the AppMetrica device identifier.
    ///
    /// - Parameter deviceID: The device identifier from AppMetrica
    func setDeviceID(_ deviceID: String) async
}
