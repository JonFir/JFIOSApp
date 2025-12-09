import Foundation
import Testing
@testable import UILoginImpl
import FactoryKit
import LibSwift
import LibSwiftUI
import LibNetwork
import LibTests
import Alamofire
import AccountStorage
import Logger
import Navigator
import UIRegistration
import UIDashbord
import FactoryTesting

@MainActor
class UILoginViewModelTests {
    var vm: UILoginViewModel!
    var dashboard: UIDashboardViewControllerMock!
    var networkProviderMock: NetworkProviderMock!
    var accountStorage: AccountStorageMock!
    var uiRegistrationViewController: UIRegistrationViewControllerMock!

    init() {
        let networkProviderMock = NetworkProviderMock()
        Container.shared.networkProvider.register { networkProviderMock }
        self.networkProviderMock = networkProviderMock

        let accountStorage = AccountStorageMock()
        Container.shared.accountStorage.register { accountStorage }
        self.accountStorage = accountStorage

        Container.shared.appNavigator.register { @MainActor in
            AppNavigatorMock()
        }

        let dashboard = UIDashboardViewControllerMock()
        Container.shared.uiDashboardViewController.register { dashboard }
        self.dashboard = dashboard

        let uiRegistrationViewController = UIRegistrationViewControllerMock()
        Container.shared.uiRegistrationViewController.register { @MainActor in
            uiRegistrationViewController
        }
        self.uiRegistrationViewController = uiRegistrationViewController

        vm = UILoginViewModelImpl()
    }

    deinit {

    }

    @Test(.container, arguments: [
        ("user@example.com", "Password123!"),
        ("test.user@domain.co.uk", "SecurePass1@"),
        ("admin@test.org", "MyP@ssw0rd"),
        ("john.doe@company.io", "Str0ng!Pass"),
        ("alice+tag@email.net", "P@ssw0rd123"),
        ("bob_123@test-site.com", "ValidP@ss1"),
        ("charlie@sub.domain.info", "Test1234#"),
        ("diana@example-domain.ru", "РусскийП@сс1"),
        ("eve@test.co", "Complex!123"),
        ("frank@example.museum", "P@ssw0rd!")
    ])
    func successLogin(email: String, password: String) async throws {
        await networkProviderMock.update { path, method, parameters, headers in
            guard
                path == "/api/collections/users/auth-with-password",
                method == .post,
                parameters?["identity"] as? String == email,
                parameters?["password"] as? String == password
            else {
                throw CommonError("")
            }

            return AuthResponse(
                token: "774d67736g8",
                record: Record(
                    collectionId: "qwe",
                    collectionName: "123",
                    id: "id_123",
                    email: "email_123",
                    emailVisibility: true,
                    verified: true,
                    name: "name_123",
                    avatar: nil,
                    created: nil,
                    updated: nil
                )
            )
        }
        vm.email = email
        vm.password = password

        let stream = Observations { [vm] in (vm.isLoading, vm.errorMessage) }
        async let collector = expectEvents(from: stream, max: 2, timeout: 1)
        await vm.login()
        let events = await collector
        let accountStorageResult = await accountStorage.saveCalls

        #expect(events.map(\.0) == [true, false], "start and stop loading")
        #expect(events.map(\.1) == [nil, nil], "error always nil")
        #expect(accountStorageResult == [Account(id: "id_123", email: "email_123", name: "name_123", token: "774d67736g8")])
        #expect(dashboard.replaceAppFlowCallCount == 1)
    }

    @Test(.container)
    func loginWithInvalidEmail() async throws {
        vm.email = "invalid-email"
        vm.password = "Password123!"

        await vm.login()

        let networkProviderCalls = await networkProviderMock.requestCallResults
        let accountStorageCalls = await accountStorage.saveCalls

        #expect(vm.isLoading == false)
        #expect(vm.errorMessage != nil)
        #expect(networkProviderCalls.isEmpty)
        #expect(accountStorageCalls.isEmpty)
    }

    @Test(.container)
    func loginWithInvalidPassword() async throws {
        vm.email = "test@test.com"
        vm.password = ""

        await vm.login()

        let networkProviderCalls = await networkProviderMock.requestCallResults
        let accountStorageCalls = await accountStorage.saveCalls

        #expect(vm.isLoading == false)
        #expect(vm.errorMessage != nil)
        #expect(networkProviderCalls.isEmpty)
        #expect(accountStorageCalls.isEmpty)
    }

    @Test(.container)
    func loginWithInvalidWholeForm() async throws {
        vm.email = ""
        vm.password = ""

        await vm.login()

        let networkProviderCalls = await networkProviderMock.requestCallResults
        let accountStorageCalls = await accountStorage.saveCalls

        #expect(vm.isLoading == false)
        #expect(vm.errorMessage != nil)
        #expect(networkProviderCalls.isEmpty)
        #expect(accountStorageCalls.isEmpty)
    }

    @Test(.container)
    func loginWithAPIErrorResponse() async throws {
        await networkProviderMock.update { path, method, parameters, headers in
            throw APIErrorResponse(message: "Wrong email or password")
        }
        
        vm.email = "test@test.com"
        vm.password = "Password123!"

        let stream = Observations { [vm] in (vm.isLoading, vm.errorMessage) }
        async let collector = expectEvents(from: stream, max: 2, timeout: 1)
        await vm.login()
        let events = await collector

        let networkProviderCalls = await networkProviderMock.requestCallResults
        let accountStorageCalls = await accountStorage.saveCalls

        #expect(events.map(\.0) == [true, false], "start and stop loading")
        let errorViewsShow = events.map(\.1)
        #expect(errorViewsShow[0] == nil)
        #expect(errorViewsShow[1] != nil)
        #expect(networkProviderCalls.count == 1)
        #expect(accountStorageCalls.isEmpty)
    }


    @Test(.container)
    func loginWithNetworkError() async throws {
        await networkProviderMock.update { path, method, parameters, headers in
            throw URLError(.notConnectedToInternet)
        }
        
        vm.email = "test@test.com"
        vm.password = "Password123!"

        let stream = Observations { [vm] in (vm.isLoading, vm.errorMessage) }
        async let collector = expectEvents(from: stream, max: 2, timeout: 1)
        await vm.login()
        let events = await collector

        let networkProviderCalls = await networkProviderMock.requestCallResults
        let accountStorageCalls = await accountStorage.saveCalls

        #expect(events.map(\.0) == [true, false], "start and stop loading")
        #expect(events.last?.1 == .unknown)
        #expect(networkProviderCalls.count == 1)
        #expect(accountStorageCalls.isEmpty)
    }

    @Test(.container, arguments: [
        (nil, "id_123"),
        ("token_123", nil)
    ] as [(String?, String?)])
    func loginWithInvalidResponse(token: String?, recordId: String?) async throws {
        await networkProviderMock.update { path, method, parameters, headers in
            return AuthResponse(
                token: token,
                record: Record(
                    collectionId: "qwe",
                    collectionName: "123",
                    id: recordId,
                    email: "email_123",
                    emailVisibility: true,
                    verified: true,
                    name: "name_123",
                    avatar: nil,
                    created: nil,
                    updated: nil
                )
            )
        }
        
        vm.email = "test@test.com"
        vm.password = "Password123!"

        let stream = Observations { [vm] in (vm.isLoading, vm.errorMessage) }
        async let collector = expectEvents(from: stream, max: 2, timeout: 1)
        await vm.login()
        let events = await collector

        let networkProviderCalls = await networkProviderMock.requestCallResults
        let accountStorageCalls = await accountStorage.saveCalls

        #expect(events.map(\.0) == [true, false], "start and stop loading")
        #expect(events.last?.1 == .unknown)
        #expect(networkProviderCalls.count == 1)
        #expect(accountStorageCalls.isEmpty)
    }

    @Test(.container)
    func loginClearsPreviousError() async throws {
        await networkProviderMock.update { path, method, parameters, headers in
            return AuthResponse(
                token: "774d67736g8",
                record: Record(
                    collectionId: "qwe",
                    collectionName: "123",
                    id: "id_123",
                    email: "email_123",
                    emailVisibility: true,
                    verified: true,
                    name: "name_123",
                    avatar: nil,
                    created: nil,
                    updated: nil
                )
            )
        }
        
        vm.email = "invalid-email"
        vm.password = "Password123!"
        await vm.login()
        
        let previousError = vm.errorMessage
        #expect(previousError != nil)
        
        vm.email = "test@test.com"
        vm.password = "Password123!"

        let stream = Observations { [vm] in (vm.isLoading, vm.errorMessage) }
        async let collector = expectEvents(from: stream, max: 2, timeout: 1)
        await vm.login()
        let events = await collector

        #expect(events.map(\.0) == [true, false], "start and stop loading")
        #expect(events[0].1 == nil, "errorMessage is nil when isLoading becomes true")
        #expect(events[1].1 == nil, "errorMessage remains nil after successful login")
    }

    @Test(.container)
    func showRegistration() async throws {
        vm.navigateToRegistration()

        #expect(uiRegistrationViewController.showCallCount == 1)
    }

}
