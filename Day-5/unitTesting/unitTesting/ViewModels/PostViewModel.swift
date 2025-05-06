import Foundation

@Observable
class PostViewModel {
    var posts: [Post] = []
    var errorMessage: String?

    private let service: PostService

    init(service: PostService = PostService()) {
        self.service = service
    }

    func loadPosts() async {
        do {
            posts = try await service.fetchPosts()
        } catch {
            errorMessage = "Failed to load posts"
        }
    }
}
