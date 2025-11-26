import SwiftUI
import FactoryKit

struct UILoginView: View {
    @State var vm = resolve(\.uiLoginViewModel)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
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
            
            if let errorMessage = vm.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: { vm.login() }) {
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(vm.isLoading)
            
            Spacer()
        }
        .padding()
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

