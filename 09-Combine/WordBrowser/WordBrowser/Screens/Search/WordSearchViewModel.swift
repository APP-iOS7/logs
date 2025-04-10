//
//  WordSearchViewModel.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

@Observable
class WordSearchViewModel {
  var searchTerm: String = ""
  var wordResult: Word? = nil
  var isLoading: Bool = false
  var errorMessage: String?
  
  // WordSearchView의 onSubmit에서 사용
  func executeQuery() async {
    guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    print("쿼리 실행: \(searchTerm)")
    isLoading = true
    errorMessage = nil
    wordResult = nil // 이전 결과 지우기
    
    do {
      let result = try await APIClient.search(for: searchTerm)
      self.wordResult = result
      print("\(searchTerm) 쿼리 성공")
    } catch let error as WordsAPIError {
      self.errorMessage = error.localizedDescription
      print("\(searchTerm) 쿼리 실패: \(error.localizedDescription)")
    } catch {
      self.errorMessage = "예상치 못한 오류 발생: \(error.localizedDescription)"
      print("\(searchTerm) 쿼리 실패: 예상치 못한 오류 \(error)")
    }
    isLoading = false
  }
  
}
