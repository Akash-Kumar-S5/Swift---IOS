import SwiftUI
import ComposableArchitecture

struct NumberFactView: View {
    let store: StoreOf<NumberFactFeature>

    var body: some View {
        VStack(spacing: 16) {
            Text("Count: \(store.count)")
                .font(.largeTitle)

            HStack(spacing: 20) {
                Button("−") { store.send(.decrement) }
                Button("+") { store.send(.increment) }
            }
            
            HStack(spacing: 20) {
                Button("Square") { store.send(.squareOf) }
                    .buttonStyle(.borderedProminent)
                Button("Fetch Fact") { store.send(.fetchFact) }
                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
                Button("Clear") { store.send(.clear) }
                    .buttonStyle(.borderedProminent)
                    .colorInvert()
            }
            

            if let fact = store.fact {
                Text(fact)
                    .padding()
                    .background(Color.gray.opacity(0.2))
            }
        }
        .padding()
    }
}

#Preview {
    NumberFactView(
      store: Store<NumberFactFeature.State, NumberFactFeature.Action>(
        initialState: NumberFactFeature.State(),
        reducer: {
            NumberFactFeature()
        }
      )
    )
}
