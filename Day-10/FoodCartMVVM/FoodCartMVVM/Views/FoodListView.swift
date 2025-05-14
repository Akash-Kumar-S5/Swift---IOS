import SwiftUI

struct FoodListView: View {
    @StateObject private var viewModel = FoodListViewModel()
    
    var body: some View {
        NavigationStack {
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

#Preview {
    FoodListView()
}
