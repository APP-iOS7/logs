//
//  OnDemandBookDetailsViewWithClosures.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//
import Combine
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

private class BookDetailViewModel: ObservableObject {
  @Published var book = Book.empty
  @Published var errorMessage: String?

  private var db = Firestore.firestore()

  init() {
    // Subscribe to the snapshot publisher
    db.collection("books").document("hitchhiker").snapshotPublisher()
      .tryMap { documentSnapshot in
        try documentSnapshot.data(as: Book.self)
      }
      .catch { error in
        self.errorMessage = error.localizedDescription
        return Just(Book.empty).eraseToAnyPublisher()
      }
      .replaceError(with: Book.empty)
      .assign(to: &$book)
  }
}

struct OnDemandBookDetailsViewWithCombine: View {
  @StateObject private var viewModel = BookDetailViewModel()

  var body: some View {
    Form {
      Section {
        Text(viewModel.book.title)
          .font(.title)
          .padding()
        Text(viewModel.book.author)
          .font(.headline)
          .padding()
        Text("\(viewModel.book.numberOfPages) pages")
          .font(.subheadline)
          .padding()
      } footer: {
        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .padding()
        }
      }
    }
    .navigationTitle("Book Details")
  }
}
