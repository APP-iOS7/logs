//
//  PostDetailViewModel.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import Foundation
import FirebaseFirestore

// PostDetailViewModel.swift
@MainActor
class PostDetailViewModel: ObservableObject {
  @Published var post: Post? // 게시글 정보도 로드
  @Published var comments: [Comment] = []
  @Published var isLoadingPost = false
  @Published var isLoadingComments = false
  @Published var errorMessage: String?

  private var db = Firestore.firestore()
  private var commentsListenerRegistration: ListenerRegistration?
  private var authViewModel = AuthViewModel() // 사용자 정보 접근

  func fetchPost(postId: String) async {
    isLoadingPost = true
    errorMessage = nil
    do {
      self.post = try await db.collection("posts").document(postId).getDocument(as: Post.self)
    } catch {
      errorMessage = "Error fetching post: \(error.localizedDescription)"
    }
    isLoadingPost = false
  }

  func subscribeToComments(postId: String) {
    guard commentsListenerRegistration == nil else { return } // 중복 구독 방지
    isLoadingComments = true
    errorMessage = nil

    let query = db.collection("posts")
      .document(postId).collection("comments")
      .order(by: "createdAt", descending: false) // 시간순 정렬

    commentsListenerRegistration = query.addSnapshotListener { [weak self] querySnapshot, error in // [32, 113]
      guard let self = self else { return }
      if let error = error {
        self.errorMessage = "Error listening for comments: \(error.localizedDescription)"
        self.isLoadingComments = false
        return
      }

      guard let snapshot = querySnapshot else {
        self.errorMessage = "Snapshot is nil"
        self.isLoadingComments = false
        return
      }

      // documentChanges를 사용하여 효율적으로 업데이트 [113, 114]
      snapshot.documentChanges.forEach { diff in
        guard let comment = try? diff.document.data(as: Comment.self) else {
          print("Failed to decode comment: \(diff.document.documentID)")
          return
        }

        if (diff.type == .added) {
          // 이미 존재하는지 확인 후 추가 (중복 방지)
          if !self.comments.contains(where: { $0.id == comment.id }) {
            // createdAt 기준으로 정렬된 위치에 삽입하거나, 간단히 append 후 정렬
            self.comments.append(comment)
            // self.comments.sort { $0.createdAt?.dateValue()?? Date() < $1.createdAt?.dateValue()?? Date() } // 필요시 정렬
            print("Comment added: \(comment.id ?? "N/A")")
          }
        }
        if (diff.type == .modified) {
          if let index = self.comments.firstIndex(where: { $0.id == comment.id }) {
            self.comments[index] = comment
            print("Comment modified: \(comment.id ?? "N/A")")
          }
        }
        if (diff.type == .removed) {
          if let index = self.comments.firstIndex(where: { $0.id == comment.id }) {
            self.comments.remove(at: index)
            print("Comment removed: \(comment.id ?? "N/A")")
          }
        }
      }
      // 초기 로딩 완료 표시 (documentChanges가 비어있지 않을 때 또는 최초 호출 시)
      if !snapshot.documentChanges.isEmpty || self.isLoadingComments {
        self.isLoadingComments = false
      }
    }
  }
  func unsubscribeFromComments() {
    commentsListenerRegistration?.remove()
    commentsListenerRegistration = nil
    print("Unsubscribed from comments")
  }

  func addComment(text: String, postId: String) async {
    guard let user = authViewModel.userSession, let userProfile = authViewModel.currentUser,!text.isEmpty else {
      errorMessage = "Cannot add comment. User not logged in or text is empty."
      return
    }
    errorMessage = nil // 이전 오류 메시지 초기화

    let newComment = Comment(
      content: text,
      authorId: user.uid,
      authorDisplayName: userProfile.displayName,
      postId: postId,
      createdAt: nil // @ServerTimestamp가 처리
    )

    do {
      // 서브컬렉션에 댓글 추가
      _ = try await db.collection("posts").document(postId).collection("comments").addDocument(from: newComment) // [6, 17]
      print("Comment added successfully")
      // 성공 시 입력 필드 초기화 등 추가 작업 가능
    } catch {
      print("Error adding comment: \(error)")
      errorMessage = "Failed to add comment: \(error.localizedDescription)"
    }
  }

  func deleteComment(comment: Comment) async {
    guard let commentId = comment.id else {
      errorMessage = "Comment ID is nil"
      return
    }
    do {
      try await db.collection("posts").document(comment.postId).collection("comments").document(commentId).delete()
      print("Comment deleted successfully")
    } catch {
      print("Error deleting comment: \(error)")
      errorMessage = "Failed to delete comment: \(error.localizedDescription)"
    }
  }

  deinit {
    weak var weakSelf = self
    Task { @MainActor [weakSelf] in
      weakSelf?.unsubscribeFromComments() // ViewModel 소멸 시 리스너 해제
    }
  }
}

