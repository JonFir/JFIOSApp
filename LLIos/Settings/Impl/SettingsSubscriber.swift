import Foundation
import Settings

final class SettingsSubscriber: Sendable {
    let callback: @Sendable (Settings) async -> Void
    
    init(callback: @escaping @Sendable (Settings) async -> Void) {
        self.callback = callback
    }
}
