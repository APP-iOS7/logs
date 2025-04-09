//
//  OnDemandBookDetailsViewWithClosures.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//
import SwiftUI
import FirebaseFirestore


private class BookListViewModel: ObservableObject {
  @Published var books: [Book] = []
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  fileprivate func fetchBooks() {
    // Firestore 의 collectionReference 를 사용하여Firestore 의 collection 을 가져온다.
    db.collection("books").getDocuments { querySnapshot, error in
      // MARK: getDocuments 클로저 START
      guard let documents = querySnapshot?.documents else {
        self.errorMessage = error?.localizedDescription
        return
      }
      
      // MARK: 도큐먼트를 Book 객체로 변환 (compactMap 을 사용하여, nil 값은 제외)
      self.books = documents.compactMap { [weak self] querySnapshotDocument in
        // Firestore document 를 Book 객체로 변환하고, 실패시 nil 반환
        let result = Result { try querySnapshotDocument.data(as: Book.self) }
        switch result {
        case .success(let book):
          self?.errorMessage = nil
          return book
        case .failure(let error):
          self?.errorMessage = error.localizedDescription
          return nil
        }
      }
      // MARK: getDocuments 클로저 END
    }
  }
}

struct ClosuresBookListView: View {
  @StateObject private var viewModel = BookListViewModel()
  
  var body: some View {
    List(viewModel.books) { book in
      Text(book.title)
    }
    .task {
      viewModel.fetchBooks()
    }
    .refreshable {
      viewModel.fetchBooks()
    }
    .navigationTitle("Book List")
  }
}
