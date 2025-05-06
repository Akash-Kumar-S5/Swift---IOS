import SwiftUI

class PostService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchPosts() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
}
