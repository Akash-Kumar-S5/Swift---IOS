import SwiftUI
import WebKit

struct WebViewDemo: View {
    var body: some View {
        WebView(url: URL(string: "https://apple.com")!)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

#Preview {
    WebViewDemo()
}
