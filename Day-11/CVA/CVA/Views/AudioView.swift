import SwiftUI

struct AudioView: View {
    @StateObject private var viewModel = AudioViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Button {
                    viewModel.isRecording
                        ? viewModel.stopRecording()
                        : viewModel.startRecording()
                } label: {
                    Label(viewModel.isRecording ? "Stop" : "Record",
                          systemImage: viewModel.isRecording ? "stop.circle" : "mic.circle")
                        .font(.largeTitle)
                        .padding()
                }

                List(viewModel.recordings, id: \.self) { url in
                    HStack {
                        Text(url.lastPathComponent)
                            .lineLimit(1)
                        Spacer()
                        Button {
                            viewModel.playRecording(url: url)
                        } label: {
                            Image(systemName:
                                viewModel.currentlyPlayingURL == url && viewModel.isPlaying
                                ? "pause.circle"
                                : "play.circle"
                            )
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .navigationTitle("Audio")
            .alert(item: $viewModel.error) { err in
                Alert(title: Text("Error"),
                      message: Text(err.localizedDescription),
                      dismissButton: .default(Text("OK")))
            }
            .onAppear {
                viewModel.requestPermission()
                viewModel.fetchRecordings()
            }
        }
    }
}
