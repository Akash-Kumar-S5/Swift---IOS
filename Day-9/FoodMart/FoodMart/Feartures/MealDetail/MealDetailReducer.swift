import ComposableArchitecture
import Foundation

@Reducer
struct MealDetailReducer {
    struct State: Equatable, Identifiable {
        let id: String
        let meal: MealItem
        var isIngredientsSheetPresented: Bool = false
    }

    enum Action: Equatable {
        case onAppear
        case toggleIngredientsSheet(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case let .toggleIngredientsSheet(isPresented):
                state.isIngredientsSheetPresented = isPresented
                return .none
            }

        }
    }
}
