//
//  FoodCardView.swift
//  FoodMart
//
//  Created by Akash Kumar S on 07/05/25.
//
import SwiftUI

struct FoodCardView: View {
    let meal: MealItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                case .failure:
                    Color.gray
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(meal.strMeal)
                    .font(.title3)
                    .bold()

                if let category = meal.strCategory {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text(meal.displayPrice)
                    .font(.headline)
                    .foregroundColor(.green)
            }

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.08))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}
