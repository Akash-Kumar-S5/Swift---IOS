//
//  ContentView.swift
//  FoodCartMVVM
//
//  Created by Akash Kumar S on 14/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = AuthViewModel()

    var body: some View {
        if viewModel.isAuthenticated {
            FoodListView(authViewModel: viewModel)
        } else {
            SignInView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
