import ComposableArchitecture
import Foundation

@Reducer
struct MealDetailReducer {
    struct State: Equatable, Identifiable {
        let id: String
        var meal: MealItem
        var isIngredientsSheetPresented: Bool = false
    }

    enum Action: Equatable {
        case onAppear
        case mealDetailResponse(Result<MealItem, MealError>)
        case toggleIngredientsSheet(Bool)
    }

    enum MealError: Error, Equatable {
        case decodingError
        case networkError(String)
    }

    @Dependency(\.urlSession) var urlSession

    func fetchMealDetails(for mealId: String) async throws -> MealItem {
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)"
        guard
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        else {
            throw MealError.networkError("Invalid URL")
        }

        let (data, _) = try await urlSession.data(from: url)
        let response = try JSONDecoder().decode(MealResponse.self, from: data)
        guard let fullMeal = response.meals?.first else {
            throw MealError.decodingError
        }
        return fullMeal
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.meal.strInstructions?.isEmpty != false else {
                    return .none
                }
                return .run { [id = state.id] send in
                    do {
                        let fullMeal = try await fetchMealDetails(for: id)
                        await send(.mealDetailResponse(.success(fullMeal)))
                    } catch {
                        await send(.mealDetailResponse(.failure(.networkError(error.localizedDescription))))
                    }
                }

            case let .mealDetailResponse(.success(fullMeal)):
                state.meal = fullMeal
                return .none

            case .mealDetailResponse(.failure):
                return .none

            case let .toggleIngredientsSheet(isPresented):
                state.isIngredientsSheetPresented = isPresented
                return .none
            }
        }
    }
}
