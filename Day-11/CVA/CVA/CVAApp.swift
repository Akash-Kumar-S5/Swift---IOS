import SwiftUI

@main
struct CVAApp: App {
    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authVM.isAuthenticated {
                MainView()  
            } else {
                AuthView(viewModel: authVM)
            }
        }
    }
}
