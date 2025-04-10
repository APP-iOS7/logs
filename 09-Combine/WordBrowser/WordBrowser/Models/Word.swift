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

// TODO: SwiftData 용 모델 추가 하거나 모델을 공유할 수 있는 방법 모색
