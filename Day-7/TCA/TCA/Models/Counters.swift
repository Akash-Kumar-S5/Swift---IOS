import ComposableArchitecture
import Foundation

@Reducer
struct NumberFactFeature {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
    }

    enum Action {
        case increment
        case decrement
        case clear
        case squareOf
        case fetchFact
        case factResponse(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .increment:
                state.count += 1
                return .none
            case .decrement:
                state.count -= 1
                return .none
            case .clear:
                state.count = 0
                state.fact = nil
                return .none
            case .squareOf:
                state.count *= state.count
                return .none
            case .fetchFact:
                return .run { [count = state.count] send in
                    let url = URL(string: "http://numbersapi.com/\(count)/trivia")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                }
            case .factResponse(let fact):
                state.fact = fact
                return .none
            }
        }
    }
}
