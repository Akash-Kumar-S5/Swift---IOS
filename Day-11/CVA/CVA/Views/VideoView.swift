import AVKit
import SwiftUI

struct VideoView: View {
    @StateObject private var viewModel = VideoViewModel()
    @State private var elapsedSeconds: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        ZStack(alignment: .top) {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()

            if viewModel.isRecording {
                Text(timeString(from: elapsedSeconds))
                    .font(.headline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(Color.black.opacity(0.5))
                    .foregroundColor(.red)
                    .clipShape(Capsule())
                    .padding(.top, 16)
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.flipCamera()
                    } label: {
                        Image(systemName: "camera.rotate")
                            .font(.title2)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
                Spacer()
            }

            VStack {
                Spacer()
                Button {
                    viewModel.isRecording
                        ? viewModel.stopRecording() : viewModel.startRecording()
                } label: {
                    Circle()
                        .fill(viewModel.isRecording ? Color.red : Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        )
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear { viewModel.configure() }
        .onReceive(timer) { _ in
            if viewModel.isRecording {
                elapsedSeconds += 1
            } else {
                elapsedSeconds = 0
            }
        }
        .alert(item: $viewModel.error) { err in
            Alert(
                title: Text("Error"),
                message: Text(err.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func timeString(from seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
