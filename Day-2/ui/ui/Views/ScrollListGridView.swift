import SwiftUI
import WebKit

struct ScrollListGridView: View {
    @State var items = (1...20).map { "Item \($0)" }

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Horizontal scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(items, id: \.self) {
                            Text($0).padding().background(Color.green.opacity(0.3)).cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }

                // List
                List(items, id: \.self) { item in
                    Text(item)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                // 1) remove the item from the array
                                if let index = items.firstIndex(of: item) {
                                    items.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .frame(height: 200)

                // LazyVGrid
                let columns = [GridItem(.adaptive(minimum: 80))]
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) {
                        Text($0)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                .padding()
            }
        }
    }
}
