import Foundation

struct MealItem: Equatable, Identifiable, Decodable {
    var id: String { idMeal }

    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strInstructions: String?
    let strMealThumb: String?
}
