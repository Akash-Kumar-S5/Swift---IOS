import ComposableArchitecture
import SwiftUI

struct FoodCategoriesView: View {
    let store: StoreOf<FoodCategoriesReducer>

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewStore.categories) { category in
                        Button(action: {
                            viewStore.send(
                                .categorySelected(category.strCategory)
                            )
                        }) {
                            Text(category.strCategory)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            viewStore.selectedCategory
                                                == category.strCategory
                                                ? Color.blue
                                                : Color.gray.opacity(0.2)
                                        )
                                )
                                .foregroundColor(
                                    viewStore.selectedCategory
                                        == category.strCategory
                                        ? .white : .primary
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 48)
                .contentShape(Rectangle())
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
