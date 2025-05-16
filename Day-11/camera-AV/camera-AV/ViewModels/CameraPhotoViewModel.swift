import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var cameraManager = CameraManager()
    
    var session: AVCaptureSession {
        cameraManager.getSession()
    }
    
    func startSession() {
        cameraManager.startSession()
    }
    
    func stopSession() {
        cameraManager.stopSession()
    }
}
