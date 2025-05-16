import AVKit
import SwiftUI

struct LibraryView: View {
    @StateObject private var vm = LibraryViewModel()
    @State private var selectedImage: UIImage?
    @State private var showImageViewer = false
    @State private var selectedVideoURL: URL?
    @State private var showVideoPlayer = false

    var body: some View {
        NavigationView {
            List {
                if !vm.photoURLs.isEmpty {
                    Section(header: Text("Photos")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(vm.photoURLs, id: \.self) { url in
                                    if let img = UIImage(
                                        contentsOfFile: url.path
                                    ) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .onTapGesture {
                                                selectedImage = img
                                                showImageViewer = true
                                            }
                                    }
                                }
                            }
                        }
                        .frame(height: 110)
                    }
                }

                if !vm.audioURLs.isEmpty {
                    Section(header: Text("Audio")) {
                        ForEach(vm.audioURLs, id: \.self) { url in
                            HStack {
                                Text(url.lastPathComponent)
                                    .lineLimit(1)
                                Spacer()
                                Button {
                                    vm.playAudio(url: url)
                                } label: {
                                    Image(
                                        systemName:
                                            vm.isPlaying
                                            && vm.currentlyPlayingURL == url
                                            ? "pause.circle"
                                            : "play.circle"
                                    )
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }

                if !vm.videoURLs.isEmpty {
                    Section(header: Text("Videos")) {
                        ForEach(vm.videoURLs, id: \.self) { url in
                            HStack {
                                Text(url.lastPathComponent)
                                    .lineLimit(1)
                                Spacer()
                                Button("Play") {
                                    selectedVideoURL = url
                                    showVideoPlayer = true
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .onAppear { vm.fetchMedia() }
            .sheet(isPresented: $showImageViewer) {
                if let img = selectedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .background(Color.black)
                }
            }
            .sheet(isPresented: $showVideoPlayer) {
                if let videoURL = selectedVideoURL {
                    VideoPlayer(player: AVPlayer(url: videoURL))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}
