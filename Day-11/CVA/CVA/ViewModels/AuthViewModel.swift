import Foundation
import AuthenticationServices
import SwiftUI

class AuthViewModel: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var authError: Error?

    func startSignInWithApple() {
        let req = ASAuthorizationAppleIDProvider().createRequest()
        req.requestedScopes = [.fullName, .email]
        let ctrl = ASAuthorizationController(authorizationRequests: [req])
        ctrl.delegate = self
        ctrl.presentationContextProvider = self
        ctrl.performRequests()
    }
}

extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
      controller: ASAuthorizationController,
      didCompleteWithAuthorization auth: ASAuthorization) {

        if let _ = auth.credential as? ASAuthorizationAppleIDCredential {
            DispatchQueue.main.async { self.isAuthenticated = true }
        } else {
            DispatchQueue.main.async { self.authError = NSError(
                domain: "Auth", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Unknown credential"])
            }
        }
    }

    func authorizationController(
      controller: ASAuthorizationController,
      didCompleteWithError error: Error) {
        DispatchQueue.main.async { self.authError = error }
    }
}

extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(
    for controller: ASAuthorizationController
  ) -> ASPresentationAnchor {
    let scenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
    let window = scenes
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }!
    return window
  }
}
