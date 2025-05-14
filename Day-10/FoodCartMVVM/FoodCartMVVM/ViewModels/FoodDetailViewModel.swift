import Foundation

@MainActor
class FoodDetailViewModel: ObservableObject {
    @Published var meal: MealItem
    @Published var isIngredientsSheetPresented = false

    init(meal: MealItem) {
        self.meal = meal
    }

    func fetchMealDetailIfNeeded() async {
        guard meal.strInstructions == nil else { return }

        let urlString =
            "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(meal.idMeal)"
        guard
            let url = URL(
                string: urlString.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                )!
            )
        else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(
                MealResponse.self,
                from: data
            )
            if let fullMeal = response.meals?.first {
                meal = fullMeal
            }
        } catch {
            print("Failed to fetch meal details: \(error.localizedDescription)")
        }
    }
}
