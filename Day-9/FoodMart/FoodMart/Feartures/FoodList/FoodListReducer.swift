// https://www.themealdb.com/api.php

import ComposableArchitecture
import Foundation

@Reducer
struct FoodListReducer {
    struct State: Equatable {
        var meals: [MealItem] = []
        var isLoading: Bool = false
        var selectedMeal: MealItem? = nil
        var categories = FoodCategoriesReducer.State()
        var hasLoadedMeals = false
    }

    enum Action: Equatable {
        case onAppear
        case mealsResponse(Result<[MealItem], MealError>)
        case mealTapped(MealItem)
        case setNavigation(Bool)
        case categories(FoodCategoriesReducer.Action)
    }

    enum MealError: Error, Equatable {
        case decodingError
        case networkError(String)
    }

    @Dependency(\.urlSession) var urlSession

    func fetchMeals(for category: String) async throws -> [MealItem] {
        let urlString =
            "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        guard
            let url = URL(
                string: urlString.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                )!
            )
        else {
            throw MealError.networkError("Invalid URL")
        }

        let (data, _) = try await urlSession.data(from: url)
        let response = try JSONDecoder().decode(MealResponse.self, from: data)
        return response.meals ?? []
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.categories, action: \.categories) {
            FoodCategoriesReducer()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                guard !state.hasLoadedMeals else {
                    state.isLoading = false
                    return .none
                }
                state.hasLoadedMeals = true

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

            case let .categories(.categorySelected(category)):
                state.categories.selectedCategory = category
                return .run { send in
                    do {
                        let meals = try await fetchMeals(for: category)
                        await send(.mealsResponse(.success(meals)))
                    } catch {
                        await send(
                            .mealsResponse(
                                .failure(
                                    .networkError(error.localizedDescription)
                                )
                            )
                        )
                    }
                }

            default:
                return .none
            }
        }
    }
}
