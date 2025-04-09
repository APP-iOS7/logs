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
  private var cancellable: AnyCancellable?

  fileprivate func subscribe() {
    cancellable = db.collection("books").snapshotPublisher()
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
      .handleEvents(receiveCancel: {
        print("Cancelled")
      })
      .assign(to: \.books, on: self)
  }

  fileprivate func unsubscribe() {
    cancellable?.cancel()
    cancellable = nil
  }
}

struct LiveBooksListViewWithCombine: View {
  @StateObject private var viewModel = BookListViewModel()

  var body: some View {
    List(viewModel.books) { book in
      Text(book.title)
    }
    .navigationTitle("Book List")
    .onAppear {
      viewModel.subscribe()
    }
    .onDisappear {
      viewModel.unsubscribe()
    }
  }
}
