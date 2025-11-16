import Foundation
import Settings

final class SettingsSubscriber: Sendable {
    let callback: @Sendable (Settings) -> Void
    
    init(callback: @escaping @Sendable (Settings) -> Void) {
        self.callback = callback
    }
}

