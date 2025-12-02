import SwiftUI
import FactoryKit
import UIComponents
import Resources

struct UILoginView: View {
    @State var vm = resolve(\.uiLoginViewModel)

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 60)
            HeaderView().padding(.bottom, 60)

            VStack(spacing: 20) {
                DefaultTextField(
                    title: String(localized: "textFiled.email.title", bundle: .module),
                    text: $vm.email
                )
                DefaultTextField(
                    title: String(localized: "textFiled.password.title", bundle: .module),
                    isSecure: true,
                    text: $vm.password
                )

                if let errorMessage = vm.errorMessage {
                    InlineErrorView(message: errorMessage.0, description: errorMessage.1)
                        .padding(.top, 4)
                        .transition(.scale(scale: 0.8, anchor: .top))
                }

                LoginButton(vm: vm)
                    .padding(.top, 12)

                RegisterButton(vm: vm)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 32)

            Spacer()
        }.backgroundGradient()
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
                vm.login()
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
                withAnimation(.spring()) {
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

#Preview {
    Container.shared.preview {
        $0.uiLoginViewModel.register { @MainActor in UILoginViewModelPrev() }
    }
    UILoginView()
}
