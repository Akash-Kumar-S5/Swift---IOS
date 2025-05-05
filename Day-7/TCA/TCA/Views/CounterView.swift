import SwiftUI
import ComposableArchitecture

struct CounterView: View {
  let store: StoreOf<CounterFeature>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 20) {
        Text("Count: \(viewStore.count)")
          .font(.largeTitle)

        HStack(spacing: 20) {
          Button("-") {
            viewStore.send(.decrementButtonTapped)
          }
          .font(.title)

          Button("+") {
            viewStore.send(.incrementButtonTapped)
          }
          .font(.title)
        }
      }
      .padding()
    }
  }
}

#Preview {
    CounterView(
      store: Store<CounterFeature.State, CounterFeature.Action>(
        initialState: CounterFeature.State(),
        reducer: {
          CounterFeature()
        }
      )
    )
}
