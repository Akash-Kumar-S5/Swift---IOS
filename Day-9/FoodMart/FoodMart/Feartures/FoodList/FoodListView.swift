import SwiftUI
import ComposableArchitecture

struct FoodListView: View {
    let store: StoreOf<FoodListReducer>

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            NavigationStack {
                List(viewStore.meals) { meal in
                    HStack(spacing: 16) {
                        
                        AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable().scaledToFill().frame(width: 80, height: 80).clipped().cornerRadius(8)
                            case .failure:
                                Color.gray.frame(width: 80, height: 80).cornerRadius(8)
                            @unknown default:
                                EmptyView()
                            }
                        }

                        VStack(alignment: .leading) {
                            Text(meal.strMeal).font(.headline)
                            if let category = meal.strCategory {
                                Text(category).font(.subheadline).foregroundColor(.gray)
                            }
                        }
                    }.padding(.vertical, 8)
                }
                .overlay {
                    if viewStore.isLoading {
                        ProgressView("Loading...")
                    }
                }
                .navigationTitle("Meals")
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

#Preview {
    FoodListView(store: Store<FoodListReducer.State, FoodListReducer.Action>(
        initialState: FoodListReducer.State(),
        reducer: {FoodListReducer()}
        )
    )
}
