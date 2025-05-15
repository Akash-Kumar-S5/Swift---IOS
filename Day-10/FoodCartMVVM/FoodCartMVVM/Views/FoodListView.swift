import SwiftUI

struct FoodListView: View {
    @StateObject private var viewModel = FoodListViewModel()
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Welcome, \(authViewModel.username)!")
                Button("Sign Out") {
                    authViewModel.signOut()
                }
                .buttonStyle(.bordered)
            }
            if viewModel.isLoading {
                ProgressView()
            }
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.meals) { meal in
                        NavigationLink {
                            FoodDetailView(meal: meal)
                        } label: {
                            FoodCardView(meal: meal)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Meals")
        }
        .task {
            await viewModel.fetchMeals()
        }
    }
}
