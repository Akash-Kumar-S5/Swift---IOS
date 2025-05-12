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
            AppView(store: Store<AppReducer.State, AppReducer.Action> (
                initialState: AppReducer.State(),
                reducer: { AppReducer()}
            )
            )
        }
    }
}
