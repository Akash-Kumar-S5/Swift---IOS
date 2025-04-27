import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var username: String = "Guest"
    
    func reset() {
        username = "Guest"
    }
}

struct SettingsView: View {
    @ObservedObject var settings: UserSettings
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, \(settings.username)!")
                .font(.title)
            
            TextField("Enter your name", text: $settings.username)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button("Reset") {
                settings.reset()
            }
        }
        .padding()
    }
}

struct GreetingView: View {
    @ObservedObject var settings: UserSettings
    
    var body: some View {
        Text("Welcome back, \(settings.username)!")
            .font(.headline)
    }
}

struct GatheredView: View {
    @StateObject private var settings = UserSettings()
    var body: some View {
            VStack {
                SettingsView(settings: settings)
                GreetingView(settings: settings)
            }
        
    }
}


#Preview {
    GatheredView()
}
