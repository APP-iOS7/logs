//
//  Book.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//

import Foundation
import FirebaseFirestore

struct Book: Codable, Identifiable {
  @DocumentID var id: String?
  var title: String
  var numberOfPages: Int
  var author: String
}

extension Book {
  static let empty = Book(title: "", numberOfPages: 0, author: "")
}
