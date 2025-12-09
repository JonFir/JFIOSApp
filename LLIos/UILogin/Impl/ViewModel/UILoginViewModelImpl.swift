import SwiftUI
import FactoryKit
import LibSwift
import LibSwiftUI
import LibNetwork
import Alamofire
import AccountStorage
import Logger
import Navigator
import UIRegistration
import UIDashbord

/// Factory provider for UILogin view model
extension Container {
    @MainActor
    var uiLoginViewModel: Factory<UILoginViewModel> {
        self { @MainActor in UILoginViewModelImpl() }
    }
}

/// Implementation of login screen view model
@Observable
final class UILoginViewModelImpl: UILoginViewModel {
    @ObservationIgnored
    @Injected(\.networkProvider)
    var networkProvider: NetworkProvider!
    @ObservationIgnored
    @Injected(\.accountStorage)
    var accountStorage: AccountStorage!
    @ObservationIgnored
    @Injected(\.logger)
    var logger: Logger!
    @ObservationIgnored
    @Injected(\.appNavigator)
    var appNavigator: AppNavigator!

    var email = ""
    var password = ""
    var isLoading: Bool = false
    var errorMessage: UILoginViewModelError? {
        didSet {
            if let errorMessage {
                logger.info(
                    "Login.ErrorMessage.Shown",
                    category: .ui,
                    module: "UILogin",
                    parameters: [
                        "title": errorMessage.title,
                        "subtitle": errorMessage.subtitle,
                    ]
                )
            }
        }
    }

    init() {}

    func login() async {
        do {
            var filedError: [String] = []
            if !(try email.matches(#"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#)) {
                logger.info("Login.Email.Invalid", category: .ui, module: "UILogin", parameters: ["email": email])
                filedError.append("Email isn't valid")
            }

            if !(try password.matches(#"^(?=.*[A-ZА-Я])(?=.*[a-zа-я])(?=.*\d)(?=.*[^A-Za-zА-Яа-я0-9]).{8,}$"#)) {
                logger.info("Login.Password.Invalid", category: .ui, module: "UILogin")
                filedError.append("Password isn't valid")
            }

            guard filedError.isEmpty else {
                throw UILoginViewModelError(
                    "Incorrect credentials",
                    filedError.joined(separator: "\n")
                )
            }

            isLoading = true
            errorMessage = nil

            let response: AuthResponse = try await networkProvider.codable(
                path: "/api/collections/users/auth-with-password",
                method: .post,
                parameters: ["identity": email, "password": password]
            )

            guard
                let id = response.record?.id,
                let token = response.token
            else {
                throw UILoginViewModelError.unknown
            }
            let account = Account(
                id: id,
                email: response.record?.email,
                name: response.record?.name,
                token: token
            )
            await accountStorage.save(account: account)
            Container.shared.uiDashboardViewController()?.replaceAppFlow()
        } catch let error as UILoginViewModelError {
            errorMessage = error
        } catch is APIErrorResponse {
            errorMessage = UILoginViewModelError(
                "Incorrect credentials",
                "Wrong email or password"
            )
        } catch {
            errorMessage = .unknown
        }
        isLoading = false
    }
    
    func navigateToRegistration() {
        Container.shared.uiRegistrationViewController()?.show()
    }

}

struct AuthResponse: Decodable {
    let token: String?
    let record: Record?
}

struct Record: Decodable {
    let collectionId: String?
    let collectionName: String?
    let id: String?
    let email: String?
    let emailVisibility: Bool?
    let verified: Bool?
    let name: String?
    let avatar: String?
    let created: String?
    let updated: String?
}
