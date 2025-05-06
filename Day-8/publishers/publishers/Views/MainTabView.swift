import SwiftUI
import WebKit


struct MainTabView: View {
    var body: some View {
        TabView {
            FirstView()
                .tabItem { Label("First", systemImage: "1.circle") }
            SecondView()
                .tabItem { Label("Second", systemImage: "globe") }
        }
    }
}

//#Preview {
//    MainTabView()
//}
