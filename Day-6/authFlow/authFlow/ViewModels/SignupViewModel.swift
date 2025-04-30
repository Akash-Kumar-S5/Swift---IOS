import Foundation
import Combine

@MainActor
class SignupViewModel: ObservableObject {
    // Inputs
    @Published var email             = ""
    @Published var password          = ""
    @Published var confirmPassword   = ""
    
    // Outputs
    @Published var isLoading         = false
    @Published var errorMsg          : String?
    @Published var didSignup         = false
    @Published var canSubmit         = false
    @Published var isEmailAvailable  = true
    @Published var emailError        : String?    // ← New!

    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // 1) local synchronous validation
        let localValidation = Publishers
            .CombineLatest3($email, $password, $confirmPassword)
            .map { email, pw, confirm in
                Validator.isValidEmail(email) &&
                Validator.isStrongPassword(pw) &&
                pw == confirm
            }

        // 2) debounced email availability check
        let emailDebounced = $email
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()

        let availability = emailDebounced
            .flatMap { [unowned self] email in
                self.authService
                    .emailAvailabilityPublisher(for: email)
            }
            .receive(on: DispatchQueue.main)
        
        // 3) drive isEmailAvailable
        availability
            .assign(to: \.isEmailAvailable, on: self)
            .store(in: &cancellables)

        // 4) derive an inline “emailError” message
        Publishers
            .CombineLatest(emailDebounced, availability)
            .map { email, available -> String? in
                // only show if user has typed something
                guard !email.isEmpty else { return nil }
                return available
                    ? nil
                    : "That email is already taken."
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.emailError, on: self)
            .store(in: &cancellables)

        // 5) overall canSubmit = localValid && availability
        Publishers
            .CombineLatest(localValidation, availability)
            .map { localValid, available in
                localValid && available
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func signUp() {
        guard canSubmit else {
            // if emailError is non-nil, show that; else show generic
            errorMsg = emailError ?? "Please fix the form."
            return
        }
        isLoading = true
        errorMsg  = nil

        authService
            .signUpPublisher(
                credentials: UserCredentials(
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword
                )
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.errorMsg = err.localizedDescription
                }
            } receiveValue: { resp in
                self.didSignup = true
            }
            .store(in: &cancellables)
    }
}
