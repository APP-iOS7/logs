//
//  CreateBoardViewModel.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import Foundation
import Combine
import FirebaseFirestore


@MainActor
class CreateBoardViewModel: ObservableObject {
  @Published var boardName: String = ""
  @Published var boardDescription: String = ""

  @Published var isLoading = false
  @Published var errorMessage: String?


  var db = Firestore.firestore()

  func createBoard() async throws {
    // 게시판 생성 로직
    // Firestore에 게시판 정보를 저장하는 코드 작성
    isLoading = true
    await db.collection("boards").addDocument(data: [
      "name": boardName,
      "description": boardDescription,
      "createdAt": Timestamp(date: Date())
    ]) { [weak self] error in
      self?.isLoading = false
      if let error = error {
        self?.errorMessage = error.localizedDescription
        print("Error creating board: \(error)")
      } else {
        self?.errorMessage = nil
        print("Board created successfully")
      }
    }
  }
}
