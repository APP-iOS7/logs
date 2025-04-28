//
//  PostListViewModel.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor // UI 업데이트를 메인 스레드에서 수행하도록 보장 [22, 41]
class PostListViewModel: ObservableObject {
  @Published var posts: [Post] = []
  @Published var isLoading = false
  @Published var errorMessage: String?

  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration? // 실시간 리스너 관리

  // 데이터 로딩 함수 (예시 - 상세 구현은 6장에서)
  func fetchPosts(boardId: String) {
    //... Firestore 쿼리 및 데이터 로딩 로직...
  }

  // 실시간 리스너 구독/해지 함수 (예시 - 상세 구현은 6장에서)
  func subscribeToPosts(boardId: String) {
    //... addSnapshotListener 로직...
  }

  func unsubscribe() {
    listenerRegistration?.remove()
    listenerRegistration = nil
  }

  deinit {
    weak var weakSelf = self
    Task { @MainActor [weakSelf] in
      weakSelf?.unsubscribe() // ViewModel 소멸 시 리스너 해제
    }
  }

  // 사용자 액션 함수 (예시)
  func deletePost(post: Post) {
    //... Firestore 문서 삭제 로직...
  }
}
