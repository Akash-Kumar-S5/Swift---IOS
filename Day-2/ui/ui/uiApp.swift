//
//  uiApp.swift
//  ui
//
//  Created by Akash Kumar S on 24/04/25.
//

import SwiftUI
import WebKit

@main
struct SwiftUIPlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

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

struct BasicsView: View {
    @State private var name = ""
     private var message = "—"

    var body: some View {
        VStack(spacing: 20) {
            Label("Enter your name:", systemImage: "person.crop.circle")
                .font(.headline)

            TextField("Your name here", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack(spacing: 10){
                Button("Greet me") {
                    self.message = "Hello, \(name.isEmpty ? "Stranger" : name)!"
                }
                .buttonStyle(.borderedProminent)
                
                Button("Clear") {
                    name = ""
                    message = "—"
                }
                .buttonStyle(.borderedProminent)
                .colorInvert()
            }
          

            Text(message)
                .font(.title2)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct ImageDemoView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Local asset image
            Image("LocalImageName")
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            // System symbol
            Label("SwiftUI", systemImage: "swift")

            // AsyncImage from URL
            AsyncImage(
                url: URL(string: "https://picsum.photos/200"),
                content: { img in
                    img.resizable()
                       .scaledToFit()
                       .frame(height: 150)
                       .cornerRadius(8)
                },
                placeholder: {
                    ProgressView()
                }
            )
        }
        .padding()
    }
}

struct ScrollListGridView: View {
    let items = (1...20).map { "Item \($0)" }

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Horizontal scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(items, id: \.self) {
                            Text($0).padding().background(Color.green.opacity(0.3)).cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }

                // List
                List(items, id: \.self) { item in
                    Text(item)
                }
                .swipeActions(content: {
                    Text("Delete")
                })
                .frame(height: 200)

                // LazyVGrid
                let columns = [GridItem(.adaptive(minimum: 80))]
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) {
                        Text($0)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                .padding()
            }
        }
    }
}

struct StacksView: View {
    var body: some View {
        VStack(spacing: 30) {
            // VStack
            VStack {
                Text("Top")
                Text("Bottom")
            }
            .padding()
            .background(Color.orange.opacity(0.3))

            // HStack
            HStack {
                Text("Left")
                Text("Right")
            }
            .padding()
            .background(Color.purple.opacity(0.3))

            // ZStack
            ZStack {
                Circle().fill(Color.red.opacity(0.3)).frame(width: 100, height: 100)
                Text("On Top")
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct WebViewDemo: View {
    var body: some View {
        WebView(url: URL(string: "https://apple.com")!)
            .edgesIgnoringSafeArea(.all)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}
