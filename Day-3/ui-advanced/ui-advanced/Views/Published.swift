import SwiftUI
import Combine

class CounterModel: ObservableObject {
    @Published var count: Int = 0

    func increment() {
        count += 1
    }
}


struct CounterView: View {
    @StateObject private var model = CounterModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(model.count)")
                .font(.largeTitle)

            Button("Increment") {
                model.increment()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    CounterView()
}
