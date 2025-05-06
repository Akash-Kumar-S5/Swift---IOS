import SwiftUI
import Combine

struct SecondView: View {
    @State private var receivedText = ""
    private var subject = SharedData.shared.subject
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack {
            Text("Received from Subject:")
            Text(receivedText)
                .font(.headline)
        }
        .onAppear {
            cancellable = subject
                .sink { value in
                    receivedText = value
                }
            print("View appeared!")
        }
        .onDisappear {
            cancellable?.cancel()
            print("View disappeared!")
        }
        .padding()
    }
}

