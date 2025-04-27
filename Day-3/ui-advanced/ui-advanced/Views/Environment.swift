import SwiftUI

struct ColorAwareView: View {
    // Pull the system color scheme into this view
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Text("Hello, world!")
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

struct ModalView: View {
   @Environment(\.presentationMode) private var presentationMode
//    @Binding var showingModel: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("This is a modal!")
                .font(.title)
            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
//                showingModel = false
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct ParentView: View {
    @State private var showingModal: Bool = false

    var body: some View {
        Button("Show Modal") {
            showingModal = true
        }
        .sheet(isPresented: $showingModal) {
//            ModalView(showingModel: $showingModal)
            ModalView()
        }
    }
}

#Preview {
    ParentView()
}
