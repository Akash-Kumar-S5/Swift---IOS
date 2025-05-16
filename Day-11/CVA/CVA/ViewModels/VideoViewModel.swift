import AVFoundation
import Foundation
import SwiftUI

class VideoViewModel: NSObject,
    ObservableObject,
    AVCaptureFileOutputRecordingDelegate
{
    @Published var error: CameraError?
    @Published var isRecording = false
    private var currentPosition: AVCaptureDevice.Position = .back

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

    func configure() {
        #if targetEnvironment(simulator)
            isConfigured = true
        #else
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
                error = .configurationFailed
                session.commitConfiguration()
            }
        #endif
    }

    func startRecording() {
        #if targetEnvironment(simulator)
            isRecording = true
        #else
            guard !isRecording else { return }
            let docs = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docs.appendingPathComponent("video_\(UUID()).mov")
            movieOutput.startRecording(to: fileURL, recordingDelegate: self)
            isRecording = true
        #endif
    }

    func stopRecording() {
        #if targetEnvironment(simulator)
            isRecording = false
            let docs = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docs.appendingPathComponent("video_\(UUID()).mov")
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        #else
            guard isRecording else { return }
            movieOutput.stopRecording()
        #endif
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
