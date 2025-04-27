import SwiftUI
import Combine

class UserSetting: ObservableObject {
    @Published var username: String = "Stranger"
    @Published var isDarkMode: Bool = false
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
}

struct ContentsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ProfileView()
                DarkModeToggle()
            }
            .navigationTitle("EnvironmentObject")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var settings: UserSetting
    
    var body: some View {
        Text("Hello, \(settings.username)!")
            .font(.title)
            .padding()
        Text("Dark Mode: \(settings.isDarkMode ? "on": "Off")")
            
    }
}

struct DarkModeToggle: View {
    @EnvironmentObject var settings: UserSetting
    
    var body: some View {
        Toggle("Dark Mode", isOn: $settings.isDarkMode)
            .padding()
        Button("Toggle Dark Mode", action: {
            self.settings.toggleDarkMode()
        })
        .buttonStyle(.borderedProminent)
    }
    
   
}

#Preview {
    @Previewable var setting = UserSetting()
    ContentsView().environmentObject(setting)
}
