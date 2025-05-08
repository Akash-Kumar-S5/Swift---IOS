// https://www.themealdb.com/api.php

import ComposableArchitecture
import Foundation

@Reducer
struct FoodListReducer {
    struct State: Equatable {
        var meals: [MealItem] = []
        var isLoading: Bool = false
        var selectedMeal: MealItem? = nil
    }

    enum Action: Equatable {
        case onAppear
        case mealsResponse(Result<[MealItem], MealError>)
        case mealTapped(MealItem)
        case setNavigation(Bool)
    }

    enum MealError: Error, Equatable {
        case decodingError
        case networkError(String)
    }

    @Dependency(\.urlSession) var urlSession
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let (data, _) = try await urlSession.data(
                            from: URL(
                                string:
                                    "https://www.themealdb.com/api/json/v1/1/search.php?s="
                            )!
                        )
                        let decoded = try JSONDecoder().decode(
                            MealResponse.self,
                            from: data
                        )
                        await send(
                            .mealsResponse(.success(decoded.meals ?? []))
                        )
                    } catch {
                        await send(.mealsResponse(.failure(.decodingError)))
                    }
                }

            case let .mealsResponse(.success(meals)):
                state.isLoading = false
                state.meals = meals
                return .none

            case .mealsResponse(.failure):
                state.isLoading = false
                state.meals = []
                return .none

            case let .mealTapped(meal):
                state.selectedMeal = meal
                return .none

            case .setNavigation(false):
                state.selectedMeal = nil
                return .none

            default:
                return .none
            }
        }
    }
}
