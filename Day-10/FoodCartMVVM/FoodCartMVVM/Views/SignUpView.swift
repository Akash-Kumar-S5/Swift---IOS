import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign Up").font(.largeTitle).bold()

            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            Button("Create Account") {
                viewModel.signUp()
            }
            .buttonStyle(.borderedProminent)

            if let error = viewModel.signUpErrorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .padding()
    }
}
