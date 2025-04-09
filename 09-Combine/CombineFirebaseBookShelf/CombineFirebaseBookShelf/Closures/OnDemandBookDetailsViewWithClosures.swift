//
//  OnDemandBookDetailsViewWithClosures.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//
import SwiftUI
import FirebaseFirestore

private class BookDetailViewModel: ObservableObject {
  @Published var book = Book.empty
  @Published var errorMessage: String?

  private var db = Firestore.firestore()

  fileprivate func fetchBook() {
    // Firestore 의 documentReference 를 사용하여
    let docRef = db.collection("books").document("hitchhiker")

    // Firestore 의 document 를 가져온다.
    docRef.getDocument(as: Book.self) { result in
      switch result {
      case .success(let book):
        self.book = book
        self.errorMessage = nil
      case .failure(let error):
        self.book = Book.empty
        self.errorMessage = error.localizedDescription
      }
    }
  }
}

struct OnDemandBookDetailsViewWithClosures: View {
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
