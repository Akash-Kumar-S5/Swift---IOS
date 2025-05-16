import SwiftUI
import AVKit

private enum ActiveSheet: Identifiable {
    case image(UIImage)
    case video(URL)

    var id: String {
        switch self {
        case .image(let img):   return "image-\(img.hashValue)"
        case .video(let url):   return "video-\(url.absoluteString)"
        }
    }
}

struct LibraryView: View {
    @StateObject private var vm = LibraryViewModel()
    @State private var activeSheet: ActiveSheet?

    var body: some View {
        NavigationView {
            List {
                if !vm.photoURLs.isEmpty {
                    Section("Photos") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(vm.photoURLs, id: \.self) { url in
                                    if let img = UIImage(contentsOfFile: url.path) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .onTapGesture {
                                                activeSheet = .image(img)
                                            }
                                    }
                                }
                            }
                        }
                        .frame(height: 110)
                    }
                }

                if !vm.audioURLs.isEmpty {
                    Section("Audio") {
                        ForEach(vm.audioURLs, id: \.self) { url in
                            HStack {
                                Text(url.lastPathComponent)
                                    .lineLimit(1)
                                Spacer()
                                Button {
                                    vm.playAudio(url: url)
                                } label: {
                                    Image(systemName:
                                        vm.isPlaying && vm.currentlyPlayingURL == url
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
                    Section("Videos") {
                        ForEach(vm.videoURLs, id: \.self) { url in
                            HStack {
                                Text(url.lastPathComponent)
                                    .lineLimit(1)
                                Spacer()
                                Button("Play") {
                                    activeSheet = .video(url)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .onAppear { vm.fetchMedia() }
      
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .image(let img):
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .background(Color.black)
                case .video(let url):
                    VideoPlayer(player: AVPlayer(url: url))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}
