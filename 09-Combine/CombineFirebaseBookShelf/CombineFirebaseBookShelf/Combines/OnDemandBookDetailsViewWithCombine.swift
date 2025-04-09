//
//  OnDemandBookDetailsViewWithClosures.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

private class BookDetailViewModel: ObservableObject {
  @Published var book = Book.empty
  @Published var errorMessage: String?

  private var db = Firestore.firestore()

  fileprivate func fetchBook() {
    db.collection("books").document("hitchhiker").getDocument()
      .tryMap { documentSnapshot in
        try documentSnapshot.data(as: Book.self)
      }
//      .catch { error in
//        self.errorMessage = error.localizedDescription
//        throw error
//      }
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
    .onAppear {
      viewModel.fetchBook()
    }
    .refreshable {
      viewModel.fetchBook()
    }
  }
}
