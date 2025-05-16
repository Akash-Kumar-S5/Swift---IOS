import AVFoundation
import Foundation
import SwiftUI

class VideoViewModel: NSObject,
    ObservableObject,
    AVCaptureFileOutputRecordingDelegate
{
    @Published var error: CameraError?
    @Published var isRecording = false

    let session = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var isConfigured = false

    enum CameraError: LocalizedError, Identifiable {
        case noCamera, configurationFailed, recordingFailed

        var id: String { localizedDescription }
        var errorDescription: String? {
            switch self {
            case .noCamera: return "No camera is available."
            case .configurationFailed: return "Failed to configure video."
            case .recordingFailed: return "Failed to record video."
            }
        }
    }

    func configure() {
        guard !isConfigured else { return }

        session.beginConfiguration()
        session.sessionPreset = .high

        guard
            let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            )
        else {
            error = .noCamera
            session.commitConfiguration()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(movieOutput) {
                session.addOutput(movieOutput)
            }
            session.commitConfiguration()
            session.startRunning()
            isConfigured = true
        } catch {
            self.error = .configurationFailed
            session.commitConfiguration()
        }
    }

    func startRecording() {
        guard let conn = movieOutput.connection(with: .video) else {
            DispatchQueue.main.async { self.error = .recordingFailed }
            return
        }
        guard !isRecording else { return }
        let docs = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
        let fileURL = docs.appendingPathComponent("video_\(UUID()).mov")
        movieOutput.startRecording(to: fileURL, recordingDelegate: self)
        isRecording = true
    }

    func stopRecording() {
        guard isRecording else { return }
        movieOutput.stopRecording()
    }

    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        DispatchQueue.main.async {
            self.isRecording = false
            if error != nil {
                self.error = .recordingFailed
            } else {
                print("Saved video to: \(outputFileURL)")
            }
        }
    }
}
