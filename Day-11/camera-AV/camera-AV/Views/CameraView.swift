import SwiftUI

struct CameraView: View {
    @StateObject var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Button(action: {
                    // Capture photo action
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}
