import SwiftUI

struct ToggleView: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle("Enable feature", isOn: $isOn)
            .padding()
    }
}

struct ContentView: View {
    @State private var featureEnabled: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Feature is \(featureEnabled ? "ON" : "OFF")")
                .font(.headline)

            ToggleView(isOn: $featureEnabled)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
