import Foundation

enum AuthError: Error, LocalizedError {
    case invalidResponse
    case server(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response."
        case .server(let msg):
            return msg
        }
    }
}

actor AuthService {
    private let usersKey = "storedUsers"
    private let defaults = UserDefaults.standard

    /// Sign-up “locally” by saving to UserDefaults.
    func signUp(credentials: UserCredentials) async throws -> AuthResponse {
        var users = loadUsers()

        // Check for duplicate
        if users.contains(where: { $0.email.lowercased() == credentials.email.lowercased() }) {
            throw AuthError.server(message: "An account with that email already exists.")
        }

        // Persist new user
        let record = StoredUser(email: credentials.email, password: credentials.password)
        users.append(record)
        saveUsers(users)

        // Return a dummy AuthResponse (e.g. you’ll later replace token with a real one)
        let fakeToken = UUID().uuidString
        return AuthResponse(userId: credentials.email, token: fakeToken)
    }

    // MARK: - Persistence helpers

    public func loadUsers() -> [StoredUser] {
        guard
          let data = defaults.data(forKey: usersKey),
          let list = try? JSONDecoder().decode([StoredUser].self, from: data)
        else {
            return []
        }
        return list
    }

    private func saveUsers(_ users: [StoredUser]) {
        if let data = try? JSONEncoder().encode(users) {
            defaults.set(data, forKey: usersKey)
        }
    }
}
