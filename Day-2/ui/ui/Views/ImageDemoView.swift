import SwiftUI
import WebKit

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

#Preview {
    ImageDemoView()
}
