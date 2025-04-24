import SwiftUI
import WebKit


struct MainTabView: View {
    var body: some View {
        TabView {
            BasicsView()
                .tabItem { Label("Basics", systemImage: "1.circle") }
            ImageDemoView()
                .tabItem { Label("Images", systemImage: "photo") }
            ScrollListGridView()
                .tabItem { Label("Scroll & Grid", systemImage: "2.circle") }
            StacksView()
                .tabItem { Label("Stacks", systemImage: "3.circle") }
            WebViewDemo()
                .tabItem { Label("Web", systemImage: "globe") }
        }
    }
}

#Preview {
    MainTabView()
}
