import ComposableArchitecture
import SwiftUI

struct MealDetailView: View {
    let store: StoreOf<MealDetailReducer>

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(
                        url: URL(string: viewStore.meal.strMealThumb ?? "")
                    ) { phase in
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
                        @unknown default: EmptyView()
                        }
                    }

                    HStack(alignment: .center) {
                        Text(viewStore.meal.strMeal)
                            .font(.title)
                            .bold()
                        Spacer()
                        Button("Show Ingredients") {
                            viewStore.send(.toggleIngredientsSheet(true))
                        }

                    }
                    .padding(.horizontal)

                    HStack(alignment: .center) {
                        if let category = viewStore.meal.strCategory {
                            Text("Category: \(category)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Text(viewStore.meal.displayPrice)
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)

                    if let instructions = viewStore.meal.strInstructions {
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
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isIngredientsSheetPresented,
                    send: { isActive in .toggleIngredientsSheet(isActive) }
                )
            ) {
                MealIngrediantList(meal: viewStore.meal)
            }
        }
    }
}
