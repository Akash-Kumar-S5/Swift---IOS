//
//  MealResponse.swift
//  FoodMart
//
//  Created by Akash Kumar S on 06/05/25.
//
import Foundation

struct MealResponse: Decodable {
    let meals: [MealItem]?
}
