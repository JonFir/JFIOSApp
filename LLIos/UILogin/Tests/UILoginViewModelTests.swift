import Foundation
import Testing
import LibTests
import FactoryKit
@testable import UILoginImpl

@Suite
@MainActor
class UILoginViewModelTests {
    var vm: UILoginViewModel!

    init() {
        self.vm = UILoginViewModelImpl()
    }

    deinit {

    }

    @Test(arguments: [
        "example@example.com",
        "test@google.com",
        "test@ya.ru"
    ])
    func loginEmailSuccessValidation(email: String) async throws {
        vm.email.text = email
        vm.email.updateValue()
        #expect(vm.email.value.value == email)
        #expect(vm.email.value.error == nil)
    }

    @Test(arguments: [
        "example_example.com",
        "@google.com",
        "test@ya.r"
    ])
    func loginEmailFailValidation(email: String) async throws {
        vm.email.text = email
        vm.email.updateValue()
        #expect(vm.email.value.value == nil)
        #expect(vm.email.value.error != nil)
    }

    @Test(arguments: [
        "ПарольTest123!",
        "Здравствуйте1@",
        "StrongPass123#",
        "!Qwertyпароль9",
        "MegaПарольTEST2024$"
    ])
    func loginPasswordSuccessValidation(password: String) async throws {
        vm.password.text = password
        vm.password.updateValue()
        #expect(vm.password.value.value == password)
        #expect(vm.password.value.error == nil)
    }

    @Test(arguments: [
        "парольtest123!",
        "PASSWORD123!",
        "ПарольTest!!!",
        "ПарольTest123",
        "Test123!Пар",
        "ОченьДлинныйПарольБезЦифр",
        "1234567890!!!@"
    ])
    func loginPasswordFailValidation(password: String) async throws {
        vm.password.text = password
        vm.password.updateValue()
        #expect(vm.password.value.value == nil)
        #expect(vm.password.value.error != nil)
    }

}
