import AVFoundation
import Foundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate
{
    @Published var error: CameraError?
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var isConfigured = false
    private var currentPosition: AVCaptureDevice.Position = .back

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
        #if targetEnvironment(simulator)
            let renderer = UIGraphicsImageRenderer(
                size: CGSize(width: 300, height: 300)
            )
            let dummy = renderer.image { ctx in
                UIColor.systemTeal.setFill()
                ctx.fill(CGRect(x: 0, y: 0, width: 300, height: 300))
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 48),
                    .foregroundColor: UIColor.white,
                ]
                let text = "📸"
                let size = text.size(withAttributes: attrs)
                let point = CGPoint(
                    x: (300 - size.width) / 2,
                    y: (300 - size.height) / 2
                )
                text.draw(at: point, withAttributes: attrs)
            }
            savePhoto(image: dummy)
        #else
            guard let connection = output.connection(with: .video) else {
                DispatchQueue.main.async { self.error = .captureFailed }
                return
            }
            if #available(iOS 17.0, *) {
                connection.videoRotationAngle = rotationAngle(for: .portrait)
            } else {
                connection.videoOrientation = .portrait
            }
            let settings = AVCapturePhotoSettings()
            output.capturePhoto(with: settings, delegate: self)
        #endif
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard
            error == nil,
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else {
            DispatchQueue.main.async { self.error = .captureFailed }
            return
        }
        savePhoto(image: image)
    }

    func flipCamera() {
        guard
            let currentInput = session.inputs
                .compactMap({ $0 as? AVCaptureDeviceInput })
                .first
        else { return }

        session.beginConfiguration()
        session.removeInput(currentInput)

        let newPosition: AVCaptureDevice.Position =
            (currentPosition == .back) ? .front : .back
        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: newPosition
        ),
            let newInput = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(newInput)
        {
            session.addInput(newInput)
            currentPosition = newPosition
        } else {
            session.addInput(currentInput)
        }

        session.commitConfiguration()
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
