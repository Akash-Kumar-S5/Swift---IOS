import SwiftUI

@MainActor
class FoodListViewModel: ObservableObject {
    @Published var meals: [MealItem] = []
    @Published var selectedMeal: MealItem?
    @Published var isLoading = false

    func fetchMeals(for category: String? = nil) async {
        isLoading = true
        defer { isLoading = false }

        let urlString: String
        if let category = category {
            urlString =
                "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        } else {
            urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s="
        }

        guard
            let url = URL(
                string: urlString.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                )!
            )
        else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(MealResponse.self, from: data)
            meals = result.meals ?? []
        } catch {
            print("Error fetching meals:", error)
        }
    }
}
