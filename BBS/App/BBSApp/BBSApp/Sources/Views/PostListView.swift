//
//  PostListView.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI

struct PostListView: View {
  @EnvironmentObject var authViewModel: AuthViewModel

  @StateObject private var viewModel = PostListViewModel()
  let boardId: String
  let boardName: String

  var body: some View {
    List(viewModel.posts) { post in
      if let postId = post.id {
        NavigationLink(destination: PostDetailView(postId: postId)) { // post.id가 nil이 아님을 보장해야 함
          VStack(alignment:.leading) {
            Text(post.title).font(.headline)
            Text(post.authorDisplayName).font(.caption)
            // Text("Comments: \(post.commentCount?? 0)") // 댓글 수 표시 (비정규화 시)
          }
        }
      } else {
        Text("Error: Post ID is nil")
      }
    }
    .navigationTitle(boardName)
    .task {
      await viewModel.fetchPosts(boardId: boardId)
    }
    // 로딩 및 오류 처리 UI 추가
    .overlay {
      if viewModel.isLoading { ProgressView() }
      else if let errorMessage = viewModel.errorMessage { Text("Error: \(errorMessage)") }
    }
    // 게시글 작성 버튼 추가 (예시)
    .toolbar {
      ToolbarItem(placement:.navigationBarTrailing) {
        NavigationLink(destination: CreatePostView(boardId: boardId)) {
          Image(systemName: "plus.circle.fill")
        }
      }
    }
  }
}
