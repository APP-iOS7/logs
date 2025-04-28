//
//  Models.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import FirebaseFirestore
import Firebase // Timestamp 사용을 위해

struct Post: Identifiable, Codable {
  @DocumentID var id: String? // Firestore 문서 ID 자동 매핑 [17, 34]
  var title: String
  var content: String
  var authorId: String // 작성자 UID
  var authorDisplayName: String // 비정규화된 작성자 이름
  var boardId: String // 게시판 ID
  var imageUrl: String? // 이미지 URL (선택적)
  var commentsCount: Int = 0 // 댓글 수
  @ServerTimestamp var createdAt: Timestamp? // 서버 시간 기준 생성 시간 [17, 34, 37]
  @ServerTimestamp var updatedAt: Timestamp? // 서버 시간 기준 수정 시간
}

struct Comment: Identifiable, Codable {
  @DocumentID var id: String?
  var content: String
  var authorId: String
  var authorDisplayName: String
  var postId: String // 댓글이 달린 게시글 ID
  @ServerTimestamp var createdAt: Timestamp?
}

struct Board: Identifiable, Codable {
  @DocumentID var id: String?
  var name: String
  var description: String?
}

struct UserProfile: Identifiable, Codable {
  @DocumentID var id: String? // Firestore 문서 ID (Auth UID와 동일하게 설정)
  var displayName: String
  var email: String
  var profileImageUrl: String?
  // isAdmin 필드는 Custom Claims를 사용하지 않을 경우 여기에 추가 가능
  // var isAdmin: Bool?
  // var roles:? // 또는 역할 배열
}
