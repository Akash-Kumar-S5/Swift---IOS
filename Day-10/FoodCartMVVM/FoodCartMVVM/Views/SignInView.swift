import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showSignUp = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign In").font(.largeTitle).bold()

            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            Button("Log In") {
                viewModel.signIn()
            }
            .buttonStyle(.borderedProminent)

            Button("Don't have an account? Sign Up") {
                showSignUp = true
            }

            if let error = viewModel.signInErrorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .padding()
        .sheet(isPresented: $showSignUp) {
            SignUpView(viewModel: viewModel)
        }
    }
}
