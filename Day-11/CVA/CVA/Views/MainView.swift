import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            PhotoView()
                .tabItem { Label("Photo", systemImage: "camera") }

            VideoView()
                .tabItem { Label("Video", systemImage: "video") }

            AudioView()
                .tabItem { Label("Audio", systemImage: "mic") }
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "photo.on.rectangle.angled")
                }
        }
    }
}
