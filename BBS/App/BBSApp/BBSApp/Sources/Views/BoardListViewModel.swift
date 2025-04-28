//
//  BoardListViewModel.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//
import FirebaseFirestore

@MainActor
class BoardListViewModel: ObservableObject {
  @Published var boards = [Board]()
  @Published var isLoading = false
  @Published var errorMessage: String?
  private var db = Firestore.firestore()

  func fetchBoards() async {
    isLoading = true
    errorMessage = nil
    do {
      let querySnapshot = try await db.collection("boards").getDocuments()
      // getDocuments(as:)를 사용하기 위해 Board 모델이 필요
      self.boards = try querySnapshot.documents.compactMap { document in
        try document.data(as: Board.self)
      }
    } catch {
      print("Error fetching boards: \(error)")
      errorMessage = error.localizedDescription
    }
    isLoading = false
  }
}
