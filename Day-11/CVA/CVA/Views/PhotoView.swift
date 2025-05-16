import SwiftUI

struct PhotoView: View {
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()

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
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                }

                Spacer()

                Button {
                    viewModel.capturePhoto()
                } label: {
                    Circle()
                        .fill(Color.white)
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
        .alert(item: $viewModel.error) { err in
            Alert(title: Text("Error"),
                  message: Text(err.localizedDescription),
                  dismissButton: .default(Text("OK")))
        }
    }
}
