import SwiftUI

struct FoodDetailView: View {
    @StateObject private var viewModel: FoodDetailViewModel

    init(meal: MealItem) {
        _viewModel = StateObject(wrappedValue: FoodDetailViewModel(meal: meal))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: viewModel.meal.strMealThumb ?? ""))
                { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                    case .failure:
                        Color.gray.frame(height: 250)
                    @unknown default:
                        EmptyView()
                    }
                }

                HStack {
                    Text(viewModel.meal.strMeal)
                        .font(.title)
                        .bold()

                    Spacer()

                    Button("Show Ingredients") {
                        viewModel.isIngredientsSheetPresented = true
                    }
                }
                .padding(.horizontal)

                HStack {
                    if let category = viewModel.meal.strCategory {
                        Text("Category: \(category)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text(viewModel.meal.displayPrice)
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding(.horizontal)

                if let instructions = viewModel.meal.strInstructions {
                    Text("Instructions:")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.horizontal)

                    Text(instructions)
                        .font(.body)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isIngredientsSheetPresented) {
            FoodIngrediantList(meal: viewModel.meal)
        }
        .task {
            await viewModel.fetchMealDetailIfNeeded()
        }
    }
}
