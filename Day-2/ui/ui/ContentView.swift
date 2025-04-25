import SwiftUI

struct NavStackDemo: View {
    let fruits = ["Apple", "Banana", "Cherry"]

    var body: some View {
        NavigationStack {
            List(fruits, id: \.self) { fruit in
                NavigationLink(value: fruit) {
                    Text(fruit)
                }
            }
            .navigationTitle("Fruits")
            .navigationDestination(for: String.self) { fruit in
                Text("You picked \(fruit)!")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
}
//
//#Preview{
//    NavStackDemo()
//}

struct ModalDemo: View {
    @State private var showSheet = false

    var body: some View {
        Button("Show Profile") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            ProfileView()
        }
    }
}

//#Preview {
//    ModalDemo()
//}

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("👤 User Profile").font(.title)
            Button("Close") {
                dismiss()
            }
        }
        .padding()
    }
}

struct TabDemo: View {
    enum Tab { case home, search, settings }
    @State private var selection: Tab = .home

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.home)

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(Tab.search)
                .badge(3)       // add a badge

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(Tab.settings)
        }
    }
}

#Preview {
    TabDemo()
}

class CounterModel: ObservableObject {
    @Published var count = 0
}

struct WrapperDemo: View {
    @StateObject private var model = CounterModel() // created once
    @AppStorage("username") private var username = "Akash"

    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, \(username)")
            Text("Count: \(model.count)")
            Button("Increment") {
                model.count += 1
            }
        }
        .padding()
    }
}

//#Preview {
//    WrapperDemo()
//}

struct HomeView: View {
    // Example state you might show on your home screen
    @State private var welcomeCount = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("🏠 Welcome Home!")
                    .font(.largeTitle)
                    .bold()

                Text("You’ve opened this tab \(welcomeCount) times.")
                    .font(.title3)

                Button("Refresh Count") {
                    welcomeCount += 1
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

struct SearchView: View {
    @State private var query = ""
    private let allItems = (1...50).map { "Item \($0)" }

    var filtered: [String] {
        guard !query.isEmpty else { return allItems }
        return allItems.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search items…", text: $query)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                List(filtered, id: \.self) { item in
                    Text(item)
                }
            }
            .navigationTitle("Search")
        }
    }
}


struct SettingsView: View {
    // Persist these to UserDefaults automatically
    @AppStorage("enableNotifications") private var enableNotifications = true
    @AppStorage("useDarkMode") private var useDarkMode = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                    Toggle("Use Dark Mode", isOn: $useDarkMode)
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
