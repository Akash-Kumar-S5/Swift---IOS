//
//  TCAApp.swift
//  TCA
//
//  Created by Akash Kumar S on 05/05/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
              store: Store(initialState: CounterFeature.State()) {
                CounterFeature()
              }
            )
        }
    }
}
