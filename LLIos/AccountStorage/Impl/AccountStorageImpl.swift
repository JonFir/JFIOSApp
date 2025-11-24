import Foundation
import AccountStorage
import LibSwift
import Logger
import Settings
import FactoryKit

public actor AccountStorageImpl: AccountStorage {
    private let observers = Observers<Account?>()
    private var currentAccount: Account?
    private let keychainKey = "AccountStorage.account"
    private let keychain: KeychainStorage
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @Injected(\.logger) private var logger: Logger?
    
    public init() {
        let settingsProvider = Container.shared.settingsProvider()!
        let host = settingsProvider.initialSettings.apiHost.absoluteString
        self.keychain = Container.shared.keychainStorageWitService(host)
    }
    
    public func save(account: Account) async {
        logger?.info(
            "Saving account",
            category: .domain,
            module: "AccountStorage",
            parameters: ["accountId": account.id, "email": account.email]
        )
        
        do {
            try keychain.setCodable(account, forKey: keychainKey)

            logger?.debug(
                "Account saved to keychain",
                category: .system,
                module: "AccountStorage",
                parameters: ["accountId": account.id]
            )
            
            currentAccount = account
            await observers.notify(account)

            logger?.info(
                "Account saved successfully",
                category: .domain,
                module: "AccountStorage",
                parameters: ["accountId": account.id]
            )
        } catch {
            logger?.critical(
                "Failed to save account to keychain",
                category: .system,
                module: "AccountStorage",
                parameters: ["accountId": account.id, "error": error.localizedDescription]
            )
        }
    }
    
    public func load() -> Account? {
        if let currentAccount = currentAccount {
            return currentAccount
        }
        
        logger?.debug(
            "Loading account",
            category: .domain,
            module: "AccountStorage"
        )
        
        do {
            guard let account: Account = try keychain.getCodable(forKey: keychainKey) else {
                logger?.debug(
                    "No account data found in keychain",
                    category: .domain,
                    module: "AccountStorage"
                )
                return nil
            }

            logger?.info(
                "Account loaded successfully",
                category: .domain,
                module: "AccountStorage",
                parameters: ["accountId": account.id, "email": account.email]
            )
            
            currentAccount = account
            return account
        } catch {
            logger?.critical(
                "Failed to load account from keychain",
                category: .system,
                module: "AccountStorage",
                parameters: ["error": error.localizedDescription]
            )
            return nil
        }
    }
    
    public func delete() async {
        logger?.info(
            "Deleting account",
            category: .domain,
            module: "AccountStorage",
            parameters: currentAccount.map { ["accountId": $0.id] } ?? [:]
        )
        
        do {
            try keychain.remove(forKey: keychainKey)
            logger?.debug(
                "Account removed from keychain",
                category: .system,
                module: "AccountStorage"
            )
        } catch {
            logger?.critical(
                "Failed to remove account from keychain",
                category: .system,
                module: "AccountStorage",
                parameters: ["error": error.localizedDescription]
            )
        }
        
        currentAccount = nil
        await observers.notify(nil)

        logger?.info(
            "Account deleted successfully",
            category: .domain,
            module: "AccountStorage"
        )
    }
    
    public func subscribe(_ callback: @escaping @Sendable (Account?) async -> Void) async -> AnySendableObject {
        logger?.debug(
            "New subscription added",
            category: .domain,
            module: "AccountStorage"
        )
        return await observers.subscribe(callback, currentAccount)
    }
}
