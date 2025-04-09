//
//  OnDemandBookDetailsViewWithClosures.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//
import Combine
import SwiftUI
import FirebaseFirestore

private class BookListViewModel: ObservableObject {
  @Published var books: [Book] = []
  @Published var errorMessage: String?

  private var db = Firestore.firestore()

  init() {
    db.collection("books").snapshotPublisher()
      // Firestore 의 collectionReference 를 사용하여Firestore 의 collection 을 가져온다.
      .map { querySnapshot in
        querySnapshot.documents.compactMap { documentSnapshot in
          try? documentSnapshot.data(as: Book.self)
        }
      }
      .catch { error in
        self.errorMessage = error.localizedDescription
        return Just([Book]()).eraseToAnyPublisher()
      }
      .replaceError(with: [Book]())
      .assign(to: &$books)
  }

}

struct CombineBookListView: View {
  @StateObject private var viewModel = BookListViewModel()

  var body: some View {
    List(viewModel.books) { book in
      Text(book.title)
    }
    .navigationTitle("Book List")
  }
}
