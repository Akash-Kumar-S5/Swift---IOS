import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppReducer>

    var body: some View {
        NavigationStack {
            FoodListView(store: store.scope(state: \.foodList, action: \.foodList))
        }
    }
}
