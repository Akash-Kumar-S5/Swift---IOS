import SwiftUI

struct AppStroagePreview: View {
    @AppStorage("username") private var username: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter your name", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()

            if !username.isEmpty {
                Text("Hello, \(username)!")
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct SceneStoragePreview: View {
    @SceneStorage("noteDraft") private var draftText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Draft Note")
                .font(.title2)

            TextEditor(text: $draftText)
                .border(Color.secondary)
                .padding(.horizontal)

            Text("Character count: \(draftText.count)")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
