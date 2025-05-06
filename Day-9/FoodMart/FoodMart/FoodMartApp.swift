//
//  FoodMartApp.swift
//  FoodMart
//
//  Created by Akash Kumar S on 06/05/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct FoodMartApp: App {
    var body: some Scene {
        WindowGroup {
            FoodListView(store: Store<FoodListReducer.State, FoodListReducer.Action>(
                initialState: FoodListReducer.State(),
                reducer: {FoodListReducer()}
                )
            )
        }
    }
}
