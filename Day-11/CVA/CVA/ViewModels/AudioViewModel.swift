import AVFoundation
import Foundation
import SwiftUI

class AudioViewModel: NSObject,
    ObservableObject,
    AVAudioRecorderDelegate,
    AVAudioPlayerDelegate
{
    enum AudioError: LocalizedError, Identifiable {
        case permissionDenied, recordingFailed, playbackFailed

        var id: String { localizedDescription }
        var errorDescription: String? {
            switch self {
            case .permissionDenied: return "Microphone access denied."
            case .recordingFailed: return "Recording failed."
            case .playbackFailed: return "Playback failed."
            }
        }
    }

    @Published var recordings: [URL] = []
    @Published var isRecording = false
    @Published var error: AudioError?
    @Published var currentlyPlayingURL: URL?
    @Published var isPlaying = false

    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?

    override init() {
        super.init()
        fetchRecordings()
    }

    func requestPermission() {
        if #available(iOS 17.0, *) {
            AVAudioApplication
                .requestRecordPermission { granted in
                    if !granted {
                        DispatchQueue.main.async {
                            self.error = .permissionDenied
                        }
                    }
                }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if !granted {
                    DispatchQueue.main.async { self.error = .permissionDenied }
                }
            }
        }
    }

    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            requestPermission()
        } catch {
            self.error = .recordingFailed
            return
        }

        let docs = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = docs.appendingPathComponent("audio_\(UUID()).m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 12_000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.delegate = self
            recorder?.record()
            isRecording = true
        } catch {
            self.error = .recordingFailed
        }
    }

    func stopRecording() {
        recorder?.stop()
        isRecording = false
        fetchRecordings()
    }

    func fetchRecordings() {
        let docs = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default
                .contentsOfDirectory(at: docs, includingPropertiesForKeys: nil)
            recordings =
                files
                .filter { $0.pathExtension == "m4a" }
                .sorted { $0.lastPathComponent < $1.lastPathComponent }
        } catch {
            print("no files found")
        }
    }

    func playRecording(url: URL) {
        if isPlaying, currentlyPlayingURL == url {
            player?.stop()
            isPlaying = false
            currentlyPlayingURL = nil
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
            currentlyPlayingURL = url
            isPlaying = true
        } catch {
            self.error = .playbackFailed
        }
    }

    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.currentlyPlayingURL = nil
        }
    }
}
