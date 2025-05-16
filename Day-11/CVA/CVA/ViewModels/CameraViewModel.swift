import AVFoundation
import Foundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate
{
    @Published var error: CameraError?
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var isConfigured = false

    enum CameraError: LocalizedError, Identifiable {
        case noCamera, configurationFailed, captureFailed

        var id: String { localizedDescription }
        var errorDescription: String? {
            switch self {
            case .noCamera:
                return "No camera is available on this device."
            case .configurationFailed:
                return "Failed to configure camera."
            case .captureFailed:
                return "Failed to capture photo."
            }
        }
    }

    func configure() {
        guard !isConfigured else { return }

        session.beginConfiguration()
        session.sessionPreset = .photo

        guard
            let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            )
        else {
            self.error = .noCamera
            session.commitConfiguration()
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            session.commitConfiguration()
            session.startRunning()
            isConfigured = true
        } catch {
            self.error = .configurationFailed
            session.commitConfiguration()
        }
    }

    func capturePhoto() {
        guard let connection = output.connection(with: .video) else {
            DispatchQueue.main.async { self.error = .captureFailed }
            return
        }
        if #available(iOS 17.0, *) {
            connection.videoRotationAngle = 90.0
        } else {
            connection.videoOrientation = .portrait
        }
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if error != nil {
            DispatchQueue.main.async { self.error = .captureFailed }
            return
        }
        guard let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else {
            DispatchQueue.main.async { self.error = .captureFailed }
            return
        }
        savePhoto(image: image)
    }

    private func savePhoto(image: UIImage) {
        let directory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
        let filename =
            directory
            .appendingPathComponent("photo_\(UUID().uuidString).jpg")
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        do {
            try data.write(to: filename)
            print("Saved photo to: \(filename)")
        } catch {
            print("Save error: \(error)")
        }
    }
}
