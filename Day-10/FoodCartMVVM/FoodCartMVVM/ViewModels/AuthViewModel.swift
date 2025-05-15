import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var signInErrorMessage: String?
    @Published var signUpErrorMessage: String?
    @Published var currentUser: User?

    private let usersKey = "users"

    private var users: [User] {
        get {
            if let data = UserDefaults.standard.data(forKey: usersKey),
               let saved = try? JSONDecoder().decode([User].self, from: data) {
                return saved
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: usersKey)
            }
        }
    }

    func signUp() {
        guard !username.isEmpty, !password.isEmpty else {
            signUpErrorMessage = "Fields cannot be empty"
            return
        }

        if users.contains(where: { $0.username == username }) {
            signUpErrorMessage = "Username already exists"
            return
        }

        let newUser = User(username: username, password: password)
        users.append(newUser)
        currentUser = newUser
        isAuthenticated = true
        signUpErrorMessage = nil
    }

    func signIn() {
        guard let matched = users.first(where: { $0.username == username && $0.password == password }) else {
            signInErrorMessage = "Invalid credentials"
            return
        }

        currentUser = matched
        isAuthenticated = true
        signInErrorMessage = nil
    }

    func signOut() {
        isAuthenticated = false
        currentUser = nil
        username = ""
        password = ""
    }
}
