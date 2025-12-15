import Foundation
import Testing
@testable import LibNetworkImpl
@testable import LibNetwork
import Settings
import FactoryKit
import FactoryTesting
import AccountStorage

@Suite(.timeLimit(.minutes(1)))
class NetworkProviderTests {

    var networkProvider: NetworkProvider!
    var accountStorage: AccountStorageMock!

    init() async throws {
        Container.shared.settingsProvider.register {
            SettingsProviderMock()
        }

        let accountStorage = AccountStorageMock()
        Container.shared.accountStorage.register { accountStorage }
        self.accountStorage = accountStorage

        networkProvider = NetworkProviderImpl()
    }

    @Test(.container)
    func authSessionWithToken() async throws {
        let loginResponse: AuthResponse = try await networkProvider.codable(
            path: "/api/collections/users/auth-with-password",
            method: .post,
            parameters: ["identity": "test@ya.ru", "password": "qweQWE1!"],
            anonimous: true
        )
        let account = try loginResponse.convertToAccount()!
        await accountStorage.save(account: account)

        let userResponse: UserDTO = try await networkProvider.codable(
            path: "/api/collections/users/records/\(loginResponse.record?.id ?? "-")",
            method: .get
        )

        #expect(loginResponse.token != nil)
        #expect(loginResponse.record?.collectionId != nil)
        #expect(loginResponse.record?.id != nil)
        #expect(userResponse.email == "test@ya.ru")
    }

    @Test(.container, .timeLimit(.minutes(1)))
    func authTokenRefreshed() async throws {
        let loginResponse: AuthResponse = try await networkProvider.codable(
            path: "/api/collections/users/auth-with-password",
            method: .post,
            parameters: ["identity": "test@ya.ru", "password": "qweQWE1!"],
            anonimous: true
        )
        let account = Account(
            id: loginResponse.record?.id ?? "",
            email: nil,
            name: nil,
            token: loginResponse.token ?? "",
            expiration: Date.now.timeIntervalSince1970 + 1000
        )
        await accountStorage.save(account: account)
        let networkProvider = NetworkProviderImpl()

        let _: UserDTO = try await networkProvider.codable(
            path: "/api/collections/users/records/\(loginResponse.record?.id ?? "-")",
            method: .get
        )

        let newAccounts = await accountStorage.saveCalls

        #expect(newAccounts.count == 2)
        #expect(newAccounts[1].expiration != account.expiration)
    }

}
