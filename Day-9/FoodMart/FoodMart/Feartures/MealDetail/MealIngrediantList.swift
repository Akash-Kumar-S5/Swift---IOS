//
//  MealIngrediantList.swift
//  FoodMart
//
//  Created by Akash Kumar S on 07/05/25.
//
import SwiftUI
struct MealIngrediantList: View {
    let meal: MealItem
    var body: some View {
        VStack {
            if meal.ingredients.isEmpty {
                Text("No ingredients listed")
            } else {
                List {
                    ForEach(meal.ingredients, id: \.ingredient) { item in
                        HStack {
                            Text(item.ingredient)
                            Spacer()
                            Text(item.measure)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .navigationTitle("Ingredients")
    }
}
