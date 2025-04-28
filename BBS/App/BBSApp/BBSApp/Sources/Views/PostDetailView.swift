//
//  PostDetailView.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI

struct PostDetailView: View {
  @StateObject private var viewModel = PostDetailViewModel()
  let postId: String
  @State private var commentText: String = ""

  var body: some View {
    VStack(alignment:.leading) {
      if viewModel.isLoadingPost {
        ProgressView("Loading post...")
      } else if let post = viewModel.post {
        Text(post.title).font(.largeTitle).padding(.bottom)
        if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
          // AsyncImage 또는 SDWebImage 등 사용하여 이미지 로드
          AsyncImage(url: url) { image in image.resizable().scaledToFit() } placeholder: { ProgressView() }
            .frame(maxHeight: 300)
            .padding(.bottom)
        }
        Text(post.content).padding(.bottom)
        Text("By \(post.authorDisplayName)").font(.caption).foregroundColor(.gray)
        Divider()

        Text("Comments").font(.headline)
        if viewModel.isLoadingComments && viewModel.comments.isEmpty {
          ProgressView("Loading comments...")
        } else if viewModel.comments.isEmpty {
          Text("No comments yet.")
        } else {
          List(viewModel.comments) { comment in
            VStack(alignment:.leading) {
              Text(comment.content)
              HStack {
                Text(comment.authorDisplayName).font(.caption2)
                Spacer()
                Text(comment.createdAt?.dateValue() ?? Date(), style:.time).font(.caption2)
              }
            }
          }
          .listStyle(.plain) // 댓글 목록 스타일 조정
        }

        // 댓글 입력 영역
        HStack {
          TextField("Add a comment...", text: $commentText)
            .textFieldStyle(.roundedBorder)
          Button {
            Task {
              await viewModel.addComment(text: commentText, postId: postId)
              if viewModel.errorMessage == nil { // 성공 시 텍스트 필드 초기화
                commentText = ""
              }
            }
          } label: {
            Image(systemName: "paperplane.fill")
          }
          .disabled(commentText.isEmpty)
        }
        .padding()

      } else if let errorMessage = viewModel.errorMessage {
        Text("Error: \(errorMessage)")
      } else {
        Text("Post not found.") // 포스트 로딩 실패 또는 없음
      }
      Spacer() // 댓글 입력창 하단 고정 위해
    }
    .padding()
    .navigationTitle("Post Details") // 네비게이션 타이틀 설정
    .task {
      await viewModel.fetchPost(postId: postId)
      viewModel.subscribeToComments(postId: postId) // 리스너 구독 시작
    }
    .onDisappear {
      viewModel.unsubscribeFromComments() // 뷰 사라질 때 구독 해지
    }
  }
}
