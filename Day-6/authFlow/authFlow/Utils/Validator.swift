import Foundation

enum Validator {
    /// Checks that the string is a well-formed email address.
    static func isValidEmail(_ email: String) -> Bool {
        // Basic RFC 5322 regex; good enough for most UIs
        let pattern =
          #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        return NSPredicate(format: "SELF MATCHES %@", pattern)
                   .evaluate(with: email)
    }

    static func isStrongPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }

        let uppercase = CharacterSet.uppercaseLetters
        let lowercase = CharacterSet.lowercaseLetters
        let digits    = CharacterSet.decimalDigits
        let special   = CharacterSet.punctuationCharacters
                         .union(.symbols)

        func contains(_ set: CharacterSet) -> Bool {
            return password.unicodeScalars.contains(where: set.contains)
        }

        return contains(uppercase)
            && contains(lowercase)
            && contains(digits)
            && contains(special)
    }

    /// Optional helper if you want to centralize confirm-password logic
    static func passwordsMatch(_ p1: String, _ p2: String) -> Bool {
        return !p1.isEmpty && p1 == p2
    }
}
