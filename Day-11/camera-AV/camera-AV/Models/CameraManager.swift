import AVFoundation

class CameraManager: NSObject, ObservableObject {
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    @Published var isSessionRunning = false
    
    override init() {
        super.init()
        configureSession()
    }
    
    private func configureSession() {
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            print("Camera permission granted: \(granted)")
        }
        
        sessionQueue.async {
            self.session.beginConfiguration()

            // Add inputs
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.session.canAddInput(videoDeviceInput) else {
                self.session.commitConfiguration() // Commit even on early return
                return
            }
            self.session.addInput(videoDeviceInput)

            // Add outputs
            let photoOutput = AVCapturePhotoOutput()
            if self.session.canAddOutput(photoOutput) {
                self.session.addOutput(photoOutput)
            }

            self.session.commitConfiguration()
            self.startSession()                
        }
    }
    
    func startSession() {
     
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
            }
        }
    }
    
    func getSession() -> AVCaptureSession {
        return session
    }
}
