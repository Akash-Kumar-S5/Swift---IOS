import Combine

extension AuthService {
  /// Wrap our async signUp call in a Combine Future
  nonisolated func signUpPublisher(
    credentials: UserCredentials
  ) -> AnyPublisher<AuthResponse, Error> {
    Future { promise in
      Task {
        do {
          let resp = try await self.signUp(credentials: credentials)
          promise(.success(resp))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

// Async check: true if no user exists with this email
  func isEmailAvailable(_ email: String) async -> Bool {
    let users = loadUsers()    // your existing UserDefaults loader
    return !users.contains { $0.email.lowercased() == email.lowercased() }
  }

  /// Wrap it as a Combine publisher
  nonisolated func emailAvailabilityPublisher(
    for email: String
  ) -> AnyPublisher<Bool, Never> {
    // Debounce & send on a background queue if you like
    Future { promise in
      Task {
        let available = await self.isEmailAvailable(email)
        promise(.success(available))
      }
    }
    .eraseToAnyPublisher()
  }

}
