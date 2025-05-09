import ComposableArchitecture
import SwiftUI

struct FoodListView: View {
    let store: StoreOf<FoodListReducer>

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        FoodCategoriesView(
                            store: store.scope(
                                state: \.categories,
                                action: \.categories
                            )
                        )
                        LazyVStack(spacing: 16) {
                            ForEach(viewStore.meals) { meal in
                                FoodCardView(meal: meal)
                                    .onTapGesture {
                                        viewStore.send(.mealTapped(meal))
                                    }
                                    .contentShape(Rectangle())
                            }
                        }
                        .padding(.top)
                    }
                    .navigationTitle("Meals")
                    .navigationDestination(
                        isPresented: viewStore.binding(
                            get: { $0.selectedMeal != nil },
                            send: { isActive in .setNavigation(isActive) }
                        )
                    ) {
                        if let meal = viewStore.selectedMeal {
                            MealDetailView(
                                store: Store(
                                    initialState: MealDetailReducer.State(
                                        id: meal.idMeal,
                                        meal: meal
                                    ),
                                    reducer: { MealDetailReducer() }
                                )
                            )
                        }
                    }
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                }
            }
        }
    }
}

//#Preview {
//    FoodListView(
//        store: Store<FoodListReducer.State, FoodListReducer.Action>(
//            initialState: FoodListReducer.State(),
//            reducer: { FoodListReducer() }
//        )
//    )
//}
