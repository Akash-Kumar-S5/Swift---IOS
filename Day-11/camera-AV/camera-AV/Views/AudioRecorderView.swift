import SwiftUI

struct AudioRecorderView: View {
    @StateObject private var viewModel = AudioRecorderViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.isRecording ? "Recording..." : "Tap to Record")
                .font(.title)
            Button(viewModel.isRecording ? "Stop Recording" : "Start Recording")
            {
                viewModel.toggleRecording()
            }

            List {
                ForEach(viewModel.recordings, id: \.self) { url in
                    HStack {
                        Text(url.lastPathComponent)
                            .lineLimit(1)
                        Spacer()
                        Button(action: {
                            viewModel.playRecording(from: url)
                        }) {
                            Image(systemName: "play.circle.fill")
                                .imageScale(.large)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadRecordings()
        }
        .padding()
    }
}
