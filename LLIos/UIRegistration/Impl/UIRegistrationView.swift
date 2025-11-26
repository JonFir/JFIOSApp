import SwiftUI
import FactoryKit

struct UIRegistrationView: View {
    @State var vm = resolve(\.uiRegistrationViewModel)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Registration")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            TextField("Email", text: $vm.email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .disabled(vm.isLoading)
            
            SecureField("Password", text: $vm.password)
                .textFieldStyle(.roundedBorder)
                .disabled(vm.isLoading)
            
            SecureField("Confirm Password", text: $vm.confirmPassword)
                .textFieldStyle(.roundedBorder)
                .disabled(vm.isLoading)
            
            if let errorMessage = vm.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: { vm.register() }) {
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Register")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(vm.isLoading)
            
            Spacer()
        }
        .padding()
    }
}

struct UIRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        Container.shared.preview {
            $0.uiRegistrationViewModel.register { @MainActor in UIRegistrationViewModelPrev() }
        }
        UIRegistrationView()
    }
}


