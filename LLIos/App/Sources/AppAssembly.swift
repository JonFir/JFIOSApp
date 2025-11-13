import UIKit
import Logger
import FirstModule
import FactoryKit
import LoggerImpl
import FirstModuleImpl

extension Container {
    @MainActor
    public var mainWindow: Factory<UIWindow> { self { @MainActor in
        return UIWindow()
    }.singleton }
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
