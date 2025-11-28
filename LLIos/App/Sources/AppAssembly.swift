import UIKit
import Logger
import FirstModule
import FactoryKit
import LoggerImpl
import FirstModuleImpl
import Settings
import SettingsImpl
import NavigatorImpl
import UISplashImpl
import AccountStorageImpl
import LibNetwork
import UILoginImpl

private nonisolated(unsafe) let autoRegisters: [AutoRegistering] = [
    LoggerAutoRegister(),
    FirstModuleAutoRegister(),
    SettingsAutoRegister(),
    NavigatorAutoRegister(),
    UISplashAutoRegister(),
    AccountStorageAutoRegister(),
    LoggerAutoRegister(),
    UILoginAutoRegister(),
]

extension Container: @retroactive AutoRegistering {
    public func autoRegister() {
        autoRegisters.forEach { $0.autoRegister() }
    }
}
