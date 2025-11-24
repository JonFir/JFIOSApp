import Foundation
import FactoryKit
import AccountStorage

public class AccountStorageAutoRegister: AutoRegistering {

    public init() {}

    public func autoRegister() {
        Container.shared.accountStorage.register { AccountStorageImpl() }
    }
}
