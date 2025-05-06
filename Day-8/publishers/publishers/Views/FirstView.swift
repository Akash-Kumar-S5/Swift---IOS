import SwiftUI

struct FirstView: View {
    @State private var name = ""
    @State private var message = "—"

    private var subject = SharedData.shared.subject

    var body: some View {
        VStack(spacing: 20) {
            Label("Enter your name:", systemImage: "person.crop.circle")
                .font(.headline)

            TextField("Your name here", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack(spacing: 10){
                Button("Greet me") {
                    message = "Hello, \(name.isEmpty ? "Stranger" : name)!"
                }
                .buttonStyle(.borderedProminent)
                
                Button("Clear") {
                    name = ""
                    message = "—"
                }
                .buttonStyle(.borderedProminent)
                .colorInvert()
            }
            
            Button("Send to Second Page") {
                subject.send(message)
            }
            .buttonStyle(.borderedProminent)
          

            Text(message)
                .font(.title2)
                .foregroundColor(.blue)
        }
        .padding()
    }
}
