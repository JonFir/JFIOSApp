import Testing
@testable import AccountStorageImpl
@testable import AccountStorage
import Logger
import Settings
import FactoryKit
import Foundation
import LibSwift

@Suite("AccountStorage Tests")
class AccountStorageTests {
    let testBundleID: String
    let testAccount: Account
    let keychainMock: KeychainStorageMock
    
    init() {
        testBundleID = "com.test.AccountStorageTests.\(UUID().uuidString)"
        
        testAccount = Account(
            id: "test-user-123",
            email: "test@example.com",
            name: "Test User",
            token: "test-token-secret"
        )
        
        let testDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        let testSettings = Settings(
            appMetricaApiKey: "test-key",
            appName: "TestApp",
            bundleID: testBundleID,
            persistenceDirectory: testDirectory
        )
        
        let mockSettingsProvider = MockSettingsProvider(settings: testSettings)
        keychainMock = KeychainStorageMock()
        
        Container.shared.logger.register {
            Logger(handlers: [])
        }
        
        Container.shared.settingsProvider.register {
            mockSettingsProvider
        }
        
        Container.shared.keychainStorageWitService.register { [keychainMock] _ in
            keychainMock
        }
    }
    
    deinit {
        keychainMock.storage.removeAll()
        Container.shared.manager.reset()
    }
    
    @Test("Save and load account")
    func saveAndLoadAccount() async {
        let storage = AccountStorageImpl()
        
        await storage.save(account: testAccount)
        
        let loadedAccount = await storage.load()
        
        #expect(loadedAccount != nil)
        #expect(loadedAccount?.id == testAccount.id)
        #expect(loadedAccount?.email == testAccount.email)
        #expect(loadedAccount?.name == testAccount.name)
        #expect(loadedAccount?.token == testAccount.token)
    }
    
    @Test("Load returns nil when no account exists")
    func loadReturnsNilWhenNoAccountExists() async {
        let storage = AccountStorageImpl()
        let loadedAccount = await storage.load()
        
        #expect(loadedAccount == nil)
    }
    
    @Test("Delete account")
    func deleteAccount() async {
        let storage = AccountStorageImpl()
        
        await storage.save(account: testAccount)
        
        var loadedAccount = await storage.load()
        #expect(loadedAccount != nil)
        #expect(!keychainMock.storage.isEmpty)

        await storage.delete()
        
        loadedAccount = await storage.load()
        #expect(loadedAccount == nil)
        #expect(keychainMock.storage.isEmpty)
    }
    
    @Test("Entire account is stored in keychain")
    func entireAccountIsStoredInKeychain() async {
        let storage = AccountStorageImpl()
        
        await storage.save(account: testAccount)
        
        let storedData = keychainMock.storage["AccountStorage.account"]
        
        #expect(storedData != nil)
        
        if let data = storedData {
            let decoder = JSONDecoder()
            let decodedAccount = try? decoder.decode(Account.self, from: data)
            
            #expect(decodedAccount?.id == testAccount.id)
            #expect(decodedAccount?.email == testAccount.email)
            #expect(decodedAccount?.name == testAccount.name)
            #expect(decodedAccount?.token == testAccount.token)
        }
    }
    
    @Test("Subscribe receives current account immediately")
    func subscribeReceivesCurrentAccountImmediately() async {
        let storage = AccountStorageImpl()
        
        await storage.save(account: testAccount)
        nonisolated(unsafe) var result: Account?

        await confirmation { confirm in
            let token = await storage.subscribe { account in
                result = account
                confirm.confirm()
            }
            _ = token
        }

        #expect(result != nil)
        #expect(result?.id == testAccount.id)
    }
    
    @Test("Subscribe receives nil when no account exists")
    func subscribeReceivesNilWhenNoAccountExists() async {
        let storage = AccountStorageImpl()

        nonisolated(unsafe) var result: Account?

        await confirmation { confirm in
            let token = await storage.subscribe { account in
                result = account
                confirm.confirm()
            }
            _ = token
        }

        #expect(result == nil)
    }
    
    @Test("Subscribe notified on save")
    func subscribeNotifiedOnSave() async {
        let storage = AccountStorageImpl()

        nonisolated(unsafe) var result: [Account?] = []

        await confirmation(expectedCount: 2) { confirm in
            let token = await storage.subscribe { account in
                result.append(account)
                confirm.confirm()
            }
            await storage.save(account: testAccount)
            _ = token
        }

        #expect(result.count == 2)
        #expect(result[0] == nil)
        #expect(result[1]?.id == testAccount.id)
    }
    
    @Test("Subscribe notified on delete")
    func subscribeNotifiedOnDelete() async {

        let storage = AccountStorageImpl()
        await storage.save(account: testAccount)

        nonisolated(unsafe) var result: [Account?] = []

        await confirmation(expectedCount: 2) { confirm in
            let token = await storage.subscribe { account in
                result.append(account)
                confirm.confirm()
            }
            await storage.delete()
            _ = token
        }

        #expect(result.count == 2)
        #expect(result[0]?.id == testAccount.id)
        #expect(result[1] == nil)
    }
    
    @Test("Overwrite existing account")
    func overwriteExistingAccount() async {
        let storage = AccountStorageImpl()
        
        await storage.save(account: testAccount)
        
        let newAccount = Account(
            id: "new-user-456",
            email: "new@example.com",
            name: "New User",
            token: "new-token-secret"
        )
        
        await storage.save(account: newAccount)
        
        let loadedAccount = await storage.load()
        
        #expect(loadedAccount?.id == newAccount.id)
        #expect(loadedAccount?.email == newAccount.email)
        #expect(loadedAccount?.name == newAccount.name)
        #expect(loadedAccount?.token == newAccount.token)
        
        let storedData = keychainMock.storage["AccountStorage.account"]
        
        #expect(storedData != nil)
        
        if let data = storedData {
            let decoder = JSONDecoder()
            let decodedAccount = try? decoder.decode(Account.self, from: data)
            
            #expect(decodedAccount?.id == newAccount.id)
        }
    }
}

actor MockSettingsProvider: SettingsProvider {
    let initialSettings: Settings
    var settings: Settings
    
    init(settings: Settings) {
        self.initialSettings = settings
        self.settings = settings
    }
    
    func subscribe(_ callback: @escaping @Sendable (Settings) async -> Void) async -> AnySendableObject {
        fatalError("Not implemented in mock")
    }
    
    func update(_ updater: @Sendable (inout Settings) -> Void) async {
        fatalError("Not implemented in mock")
    }
}
