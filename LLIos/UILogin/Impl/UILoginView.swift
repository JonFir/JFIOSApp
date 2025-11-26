import SwiftUI
import FactoryKit

struct UILoginView: View {
    @State var vm = resolve(\.uiLoginViewModel)
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.1),
                    Color(red: 0.2, green: 0.05, blue: 0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.3, blue: 0.2), Color(red: 0.9, green: 0.1, blue: 0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color(red: 1.0, green: 0.2, blue: 0.2).opacity(0.5), radius: 20)
                    
                    Text("PUSH YOUR LIMITS")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    Text("Train. Push. Conquer.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .tracking(1)
                }
                .padding(.bottom, 60)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        TextField("", text: $vm.email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .disabled(vm.isLoading)
                            .foregroundColor(.white)
                            .accentColor(Color(red: 1.0, green: 0.3, blue: 0.2))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        SecureField("", text: $vm.password)
                            .disabled(vm.isLoading)
                            .foregroundColor(.white)
                            .accentColor(Color(red: 1.0, green: 0.3, blue: 0.2))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    
                    if let errorMessage = vm.errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    }
                    
                    Button(action: { vm.login() }) {
                        HStack {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("START TRAINING")
                                    .font(.system(size: 16, weight: .bold))
                                    .tracking(1.5)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.3, blue: 0.2),
                                    Color(red: 0.9, green: 0.1, blue: 0.1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(
                            color: Color(red: 1.0, green: 0.2, blue: 0.2).opacity(0.4),
                            radius: 15,
                            y: 5
                        )
                    }
                    .disabled(vm.isLoading)
                    .padding(.top, 12)
                    
                    Button(action: { vm.navigateToRegistration() }) {
                        HStack(spacing: 4) {
                            Text("New here?")
                                .foregroundColor(.white.opacity(0.7))
                            Text("Join the Challenge")
                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.3))
                                .fontWeight(.semibold)
                        }
                        .font(.system(size: 15))
                    }
                    .disabled(vm.isLoading)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
        }
    }
}

struct UILoginView_Previews: PreviewProvider {
    static var previews: some View {
        Container.shared.preview {
            $0.uiLoginViewModel.register { @MainActor in UILoginViewModelPrev() }
        }
        UILoginView()
    }
}

