import SwiftUI

struct PostListView: View {
    @State var viewModel: PostViewModel = PostViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Posts")
            .task {
                await viewModel.loadPosts()
            }
        }
    }
}

#Preview {
    PostListView(viewModel: PostViewModel())
}
