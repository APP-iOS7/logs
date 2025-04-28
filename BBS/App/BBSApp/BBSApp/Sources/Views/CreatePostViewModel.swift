//
//  CreatePostViewModel.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import Foundation
import FirebaseFirestore

@MainActor
class CreatePostViewModel: ObservableObject {
  @Published var isUploading = false
  @Published var errorMessage: String?

  private var db = Firestore.firestore()

  func createPost(boardId: String, title: String, content: String, authViewModel: AuthViewModel, imageData: Data?) async {
    debugPrint("Creating post for board: \(boardId)")
    debugPrint("User session: \(authViewModel.userSession?.uid ?? "No user")")


    guard let user = authViewModel.userSession, let userProfile = authViewModel.currentUser else {
      errorMessage = "User not logged in."
      return
    }

    isUploading = true
    errorMessage = nil
    var imageUrl: String? = nil
    let newPostRef = db.collection("posts").document() // 새 문서 ID 미리 생성
    let postId = newPostRef.documentID

    do {
      // 1. 이미지 업로드 (선택된 경우)
      if let data = imageData {
        print("Uploading image...")
        let downloadURL = try await StorageManager.shared.uploadPostImage(imageData: data, postId: postId)
        imageUrl = downloadURL.absoluteString
      }

      // 2. Post 객체 생성
      let newPost = Post(
        id: postId, // 미리 생성한 ID 사용
        title: title,
        content: content,
        authorId: user.uid,
        authorDisplayName: userProfile.displayName, // 비정규화
        boardId: boardId,
        imageUrl: imageUrl,
        commentsCount: 0,
        createdAt: nil, // @ServerTimestamp가 처리
        updatedAt: nil  // @ServerTimestamp가 처리
      )

      // 3. Firestore에 Post 문서 저장
      print("Saving post to Firestore...")
      try newPostRef.setData(from: newPost) // [6, 35]
      print("Post created successfully with ID: \(postId)")

    } catch {
      print("Error creating post: \(error)")
      errorMessage = error.localizedDescription
      // 이미지 업로드 성공 후 Firestore 저장 실패 시, 업로드된 이미지 삭제 로직 추가 고려
    }

    isUploading = false
  }
}
