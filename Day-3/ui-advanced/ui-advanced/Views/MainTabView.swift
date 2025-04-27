import SwiftUI
import WebKit


struct MainTabView: View {
    var body: some View {
        TabView {
            sumOfDigitsView()
                .tabItem { Label("SOD", systemImage: "cross") }
            TicTacTow()
                .tabItem{ Label("TicTacToe", systemImage: "square.and.arrow.up")}
        }
    }
}

#Preview {
    MainTabView()
}
