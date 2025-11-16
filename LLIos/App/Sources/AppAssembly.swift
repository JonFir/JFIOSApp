import UIKit
import Logger
import FirstModule
import FactoryKit
import LoggerImpl
import FirstModuleImpl
import Settings
import SettingsImpl

extension Container {
    @MainActor
    public var mainWindow: Factory<UIWindow?> { promised() }
}

private nonisolated(unsafe) let autoRegisters: [AutoRegistering] = [
    LoggerAutoRegister(),
    FirstModuleAutoRegister(),
    SettingsAutoRegister(),
]

extension Container: @retroactive AutoRegistering {
    public func autoRegister() {
        autoRegisters.forEach { $0.autoRegister() }
    }
}
