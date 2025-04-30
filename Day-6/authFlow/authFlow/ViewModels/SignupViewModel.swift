import Foundation
import Combine

@MainActor
class SignupViewModel: ObservableObject {
    // Input
    @Published var email             = ""
    @Published var password          = ""
    @Published var confirmPassword   = ""
    
    // Output / state
    @Published var isLoading   = false
    @Published var errorMsg     : String?
    @Published var didSignup    = false
    
    private let authService = AuthService()
    
    var canSubmit: Bool {
        Validator.isValidEmail(email)
         && Validator.isStrongPassword(password)
         && password == confirmPassword
    }
    
    func signUp() async {
        guard canSubmit else {
            errorMsg = "Please fill all fields correctly."
            return
        }
        
        isLoading = true
        errorMsg  = nil
        
        let creds = UserCredentials(
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
        
        do {
            let resp = try await authService.signUp(credentials: creds)
            // store token/userId as needed
            print("Signed up!", resp)
            didSignup = true
        } catch {
            errorMsg = error.localizedDescription
        }
        
        isLoading = false
    }
}
