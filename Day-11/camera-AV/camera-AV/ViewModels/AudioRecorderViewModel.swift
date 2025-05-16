import AVFoundation
import Foundation

class AudioRecorderViewModel: NSObject, ObservableObject {
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    @Published var isRecording = false
    @Published var recordings: [URL] = []

    private var recordingDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[
            0
        ]
    }

    func toggleRecording() {
        if isRecording {
            recorder?.stop()
            isRecording = false
            loadRecordings()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        let filename = "Recording_\(Date().timeIntervalSince1970).m4a"
        let fileURL = recordingDirectory.appendingPathComponent(filename)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playAndRecord,
                mode: .default
            )
            try AVAudioSession.sharedInstance().setActive(true)

            recorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recorder?.delegate = self
            recorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    func loadRecordings() {
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: recordingDirectory,
                includingPropertiesForKeys: nil
            )
            self.recordings = files.filter { $0.pathExtension == "m4a" }.sorted(
                by: { $0.lastPathComponent > $1.lastPathComponent })
        } catch {
            print("Error loading recordings: \(error)")
        }
    }

    func playRecording(from url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Playback failed: \(error.localizedDescription)")
        }
    }
}

extension AudioRecorderViewModel: AVAudioRecorderDelegate {}
