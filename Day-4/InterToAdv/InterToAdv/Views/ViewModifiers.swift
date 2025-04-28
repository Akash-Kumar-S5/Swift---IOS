import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}

struct CustomModifierExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Modifier")
                .modifier(CardStyle())

            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .cardStyle()
        }
        .padding()
    }
}

#Preview {
    CustomModifierExample()
}
