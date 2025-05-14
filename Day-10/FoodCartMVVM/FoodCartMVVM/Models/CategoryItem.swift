//
//  CategoryItem.swift
//  FoodMart
//
//  Created by Akash Kumar S on 09/05/25.
//

struct CategoryItem: Equatable, Identifiable, Decodable {
    var id: String { strCategory }
    let strCategory: String
}
