import SwiftUI

struct SignupView: View {
  @StateObject private var vm = SignupViewModel()
  
  var body: some View {
    NavigationView {
      Form {
        Section("Account") {
          TextField("Email", text: $vm.email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
        if let msg = vm.emailMessage {
          Text(msg)
                .foregroundColor( vm.isEmailAvailable ? .green: .red)
            .font(.caption)
        }
          SecureField("Password", text: $vm.password)
          SecureField("Confirm Password", text: $vm.confirmPassword)
            if let msg = vm.confirmPasswordError {
              Text(msg)
                    .foregroundColor(.red)
                .font(.caption)
            }
        }
          
      if let err = vm.passwordError {
        Section {
          Text(err)
            .foregroundColor(.red)
        }
      }
        
        if let err = vm.errorMsg {
          Section {
            Text(err)
              .foregroundColor(.red)
          }
        }
        
        
          Button {
            vm.signUp()
          } label: {
            if vm.isLoading {
              ProgressView()
            } else {
              Text("Sign Up")
                .frame(maxWidth: .infinity)
            }
          }
          .disabled(!vm.canSubmit || vm.isLoading)
        }
        
      
      .navigationTitle("Create Account")
      .alert("Success!", isPresented: $vm.didSignup) {
        Button("OK") { /* navigate to next screen */ }
      } message: {
        Text("Your account was created.")
      }
    }
  }
}

#Preview {
    SignupView()
}
