import SwiftUI
import FactoryKit
import UIComponents
import Resources

private enum UILoginViewFocusedField: Int, Hashable {
   case email
   case password
}

struct UILoginView: View {
    @State var vm = resolve(\.uiLoginViewModel)
    @FocusState private var focusedField: UILoginViewFocusedField?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 60)

                HeaderView().padding(.bottom, 60)

                VStack(spacing: 20) {
                    EmailField(
                        vm: vm,
                        focusedField: $focusedField
                    )

                    PasswordField(
                        vm: vm,
                        focusedField: $focusedField
                    )

                    if let errorMessage = vm.errorMessage {
                        InlineErrorView(message: errorMessage.0, description: errorMessage.1)
                            .padding(.top, 4)
                            .transition(.slide)
                    }

                    LoginButton(vm: vm)
                        .padding(.top, 12)

                    RegisterButton(vm: vm)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 60)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .backgroundGradient()
    }
}

private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            ResourcesAsset.primaryRed.swiftUIColor,
                            ResourcesAsset.secondaryRed.swiftUIColor,
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: ResourcesAsset.shadowRed.swiftUIColor, radius: 20)

            Text("header.title", bundle: .module)
                .textStyle(.title)
                .foregroundColor(ResourcesAsset.textPrimary.swiftUIColor)

            Text("header.subtitle", bundle: .module)
                .textStyle(.subtitle)
                .foregroundColor(ResourcesAsset.textSecondary.swiftUIColor)
        }
    }
}

private struct LoginButton: View {
    let vm: UILoginViewModel

    var body: some View {
        Button(
            action: {
                withAnimation(.easeInOut) {
                    vm.login()
                }
            },
            label: {
                HStack {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("button.login.title", bundle: .module)
                            .textStyle(.primaryButton)
                        Image(systemName: "arrow.right")
                    }
                }
            }
        )
        .buttonStyle(.primary)
        .disabled(vm.isLoading)
    }
}

private struct RegisterButton: View {
    let vm: UILoginViewModel

    var body: some View {
        Button(
            action: {
                withAnimation(.easeInOut) {
                    vm.navigateToRegistration()
                }
            },
            label: {
                HStack(spacing: 4) {
                    Text("button.register.title", bundle: .module)
                        .foregroundColor(ResourcesAsset.textPrimary.swiftUIColor.opacity(0.7))
                    Text("button.register.subtitle", bundle: .module)
                        .foregroundColor(ResourcesAsset.accentLight.swiftUIColor)
                        .fontWeight(.semibold)
                }
            }
        )
        .buttonStyle(.inline)
        .disabled(vm.isLoading)
    }
}

private struct EmailField: View {
    let vm: UILoginViewModel
    @FocusState.Binding var focusedField: UILoginViewFocusedField?

    var body: some View {
        DefaultTextField(
            title: String(localized: "textFiled.email.title", bundle: .module),
            text: .init(get: { vm.email }, set: { vm.email = $0 })
        )
        .focused($focusedField, equals: .email)
        .submitLabel(.next)
        .onSubmit {
            focusedField = .password
        }
    }
}

private struct PasswordField: View {
    let vm: UILoginViewModel
    @FocusState.Binding var focusedField: UILoginViewFocusedField?

    var body: some View {
        DefaultTextField(
            title: String(localized: "textFiled.password.title", bundle: .module),
            isSecure: true,
            text: .init(get: { vm.password }, set: { vm.password = $0 })
        )
        .focused($focusedField, equals: .password)
        .submitLabel(.done)
        .onSubmit {
            vm.login()
        }
    }
}

#Preview {
    Container.shared.preview {
        $0.uiLoginViewModel.register { @MainActor in UILoginViewModelPrev() }
    }
    UILoginView()
}
