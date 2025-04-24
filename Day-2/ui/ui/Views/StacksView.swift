import SwiftUI
import WebKit

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
