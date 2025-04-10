//
//  Word.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import Foundation

struct Word: Codable, Identifiable {
  var id: String { word }
  let word: String
  let results: [WordResult]?
  let pronunciation: Pronunciation?

  static let empty = Word(word: "", results: nil, pronunciation: nil)
}
