import UIKit
import Logger
import FirstModule
import FactoryKit
import LoggerImpl
import FirstModuleImpl

extension Container {
    @MainActor
    public var mainWindow: Factory<UIWindow?> { promised() }
}

private nonisolated(unsafe) let autoRegisters: [AutoRegistering] = [
    LoggerAutoRegister(),
    FirstModuleAutoRegister(),
]

extension Container: @retroactive AutoRegistering {
    public func autoRegister() {
        autoRegisters.forEach { $0.autoRegister() }
    }
}
