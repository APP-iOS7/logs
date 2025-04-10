//
//  WordResult.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import Foundation

struct WordResult: Codable, Identifiable {
  var id = UUID() // ForEach를 위한 안정적인 식별자 추가
  let definition: String?
  let partOfSpeech: String?
  let synonyms: [String]?
  let typeOf: [String]?
  let examples: [String]?

  // 'partOfSpeech'의 대소문자가 다를 수 있으므로 CodingKeys 필요
  enum CodingKeys: String, CodingKey {
    case definition, partOfSpeech, synonyms, typeOf, examples
  }
}
