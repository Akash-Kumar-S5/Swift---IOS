import AVFoundation
import Foundation
import SwiftUI

class LibraryViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var photoURLs: [URL] = []
    @Published var audioURLs: [URL] = []
    @Published var videoURLs: [URL] = []
    @Published var currentlyPlayingURL: URL?
    @Published var isPlaying = false

    private var audioPlayer: AVAudioPlayer?

    func fetchMedia() {
        let docs = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default
                .contentsOfDirectory(at: docs, includingPropertiesForKeys: nil)
            photoURLs = files.filter { $0.pathExtension.lowercased() == "jpg" }
            audioURLs = files.filter { $0.pathExtension.lowercased() == "m4a" }
            videoURLs = files.filter {
                let ext = $0.pathExtension.lowercased()
                return ext == "mov" || ext == "mp4"
            }
        } catch {
            print("Media fetch error:", error)
        }
    }

    func playAudio(url: URL) {
        if isPlaying && currentlyPlayingURL == url {
            audioPlayer?.stop()
            isPlaying = false
            currentlyPlayingURL = nil
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            currentlyPlayingURL = url
            isPlaying = true
        } catch {
            print("Audio play error:", error)
        }
    }

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
