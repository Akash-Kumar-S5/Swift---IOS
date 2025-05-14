import Foundation

struct MealItem: Equatable, Identifiable, Decodable {
    var id: String { idMeal }

    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strInstructions: String?
    let strMealThumb: String?

    public let strIngredient1: String?
    public let strIngredient2: String?
    public let strIngredient3: String?
    public let strIngredient4: String?
    public let strIngredient5: String?
    public let strIngredient6: String?
    public let strIngredient7: String?
    public let strIngredient8: String?
    public let strIngredient9: String?
    public let strIngredient10: String?
    public let strIngredient11: String?
    public let strIngredient12: String?
    public let strIngredient13: String?
    public let strIngredient14: String?
    public let strIngredient15: String?
    public let strIngredient16: String?
    public let strIngredient17: String?
    public let strIngredient18: String?
    public let strIngredient19: String?
    public let strIngredient20: String?

    public let strMeasure1: String?
    public let strMeasure2: String?
    public let strMeasure3: String?
    public let strMeasure4: String?
    public let strMeasure5: String?
    public let strMeasure6: String?
    public let strMeasure7: String?
    public let strMeasure8: String?
    public let strMeasure9: String?
    public let strMeasure10: String?
    public let strMeasure11: String?
    public let strMeasure12: String?
    public let strMeasure13: String?
    public let strMeasure14: String?
    public let strMeasure15: String?
    public let strMeasure16: String?
    public let strMeasure17: String?
    public let strMeasure18: String?
    public let strMeasure19: String?
    public let strMeasure20: String?
}

extension MealItem {
    var displayPrice: String {
        let price = Double(idMeal.suffix(2)) ?? Double.random(in: 5...20)
        return String(format: "$%.2f", price)
    }

    var ingredients: [(ingredient: String, measure: String)] {
        let mirror = Mirror(reflecting: self)

        let ingredients: [(String, String)] = (1...20).compactMap { index in
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"

            guard
                let ingredient = mirror.children.first(where: {
                    $0.label == ingredientKey
                })?.value as? String,
                let measure = mirror.children.first(where: {
                    $0.label == measureKey
                })?.value as? String,
                !ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty
            else {
                return nil
            }

            return (ingredient, measure)
        }

        return ingredients
    }
}
