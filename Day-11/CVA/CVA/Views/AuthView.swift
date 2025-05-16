import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Text("Welcome to CameraApp")
                .font(.largeTitle)
            SignInWithAppleButton(
                .signIn,
                onRequest: { req in
                    viewModel.startSignInWithApple()
                },
                onCompletion: { result in
                    
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 45)
            .padding(.horizontal, 50)
            Spacer()
        }
        
    }
}
