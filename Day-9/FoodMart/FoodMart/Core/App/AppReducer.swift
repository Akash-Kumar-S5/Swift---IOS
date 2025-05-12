import ComposableArchitecture

@Reducer
struct AppReducer {
    struct State: Equatable {
        var foodList = FoodListReducer.State()
    }

    enum Action {
        case foodList(FoodListReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.foodList, action: \.foodList) { FoodListReducer() }
    }
}
