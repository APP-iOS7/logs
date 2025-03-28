//
//  SharedData.swift
//  JRNL
//
//  Created by Jungman Bae on 3/28/25.
//

import Foundation

class SharedData {
  // MARK: - Properties
  static let shared = SharedData()
  private var journalEntries: [JournalEntry]

  // MARK: - Initializer
  private init() {
    journalEntries = []
  }

  // MARK: access methods

  var numberOfJournalEntries: Int {
    return journalEntries.count
  }

  // 전체 데이터 반환
  func getAllJournalEntries() -> [JournalEntry] {
    return journalEntries
  }

  func getJournalEntry(at index: Int) -> JournalEntry {
    return journalEntries[index]
  }

  // 데이터 추가
  func addJournalEntry(_ entry: JournalEntry) {
    journalEntries.append(entry)
  }

  // 데이터 삭제
  func removeJournalEntry(at index: Int) {
    journalEntries.remove(at: index)
  }
}
