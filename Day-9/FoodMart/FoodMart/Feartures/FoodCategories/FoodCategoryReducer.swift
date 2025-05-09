import ComposableArchitecture
import SwiftUI

@Reducer
struct FoodCategoriesReducer {
    struct State: Equatable {
        var categories: [CategoryItem] = []
        var selectedCategory: String?
    }

    enum Action: Equatable {
        case onAppear
        case categoriesResponse(Result<[CategoryItem], MealError>)
        case categorySelected(String)
    }

    enum MealError: Error, Equatable {
        case decodingError
        case networkError(String)
    }

    func fetchCategories() async throws -> [CategoryItem] {
        let url = URL(
            string: "https://www.themealdb.com/api/json/v1/1/list.php?c=list"
        )!
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(CategoryResponse.self, from: data)
        return result.meals
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let categories = try await fetchCategories()
                        await send(.categoriesResponse(.success(categories)))
                    } catch {
                        await send(
                            .categoriesResponse(
                                .failure(
                                    .networkError(error.localizedDescription)
                                )
                            )
                        )
                    }
                }

            case let .categoriesResponse(.success(categories)):
                state.categories = categories
                return .none

            case let .categorySelected(category):
                state.selectedCategory = category
                return .none

            case .categoriesResponse(.failure):
                return .none
            }
        }
    }
}
