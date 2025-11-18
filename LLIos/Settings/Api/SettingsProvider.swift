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
/// let settings = await provider.settings
///
/// await provider.subscribe { updatedSettings in
///     print("Settings updated: \(updatedSettings)")
/// }
///
/// await settingsProvider?.update {
///     $0.deviceID = deviceID
/// }
/// ```
public protocol SettingsProvider: Actor {
    /// The app's initial settings don't change over time.
    nonisolated var initialSettings: Settings { get }

    /// Current settings, subject to change.
    /// Use `subscribe` to track modifications.
    var settings: Settings { get }
    
    /// Subscribes to settings changes with automatic cleanup when token is deallocated.
    ///
    /// Multiple subscribers are supported. Callbacks are invoked whenever settings change.
    /// Keep the returned token alive as long as you want to receive updates.
    ///
    /// - Parameter callback: Closure called when settings are updated
    /// - Returns: Subscription token that must be retained to keep subscription active
    func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnySendableObject

    /// Changing current settings.
    /// Notifies subscribers upon change.
    func update(_ updater: @Sendable (inout Settings) -> Void) async
}
