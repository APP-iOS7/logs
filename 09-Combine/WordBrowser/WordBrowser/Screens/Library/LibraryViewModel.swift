//
//  LibraryViewModel.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

@Observable
class LibraryViewModel {
  var randomWord: Word?
  var isRefreshing: Bool = false
  var refreshError: String? = nil

  func refresh(initialLoad: Bool = false) async {
    if !initialLoad { // 맨 처음 로드에는 스피너 표시 안 함
      isRefreshing = true
    }
    refreshError = nil
    debugPrint("LibraryViewModel: 새로고침 트리거됨")

    do {
      let result = try await APIClient.fetchRandomWord()
      self.randomWord = result
      debugPrint("LibraryViewModel: 새로고침 성공, '\(result.word)' 가져옴")
    } catch let error as WordsAPIError {
      self.refreshError = error.localizedDescription
      debugPrint("LibraryViewModel: 새로고침 실패: \(error.localizedDescription)")
    } catch {
      self.refreshError = "새로고침 중 예상치 못한 오류 발생: \(error.localizedDescription)"
      debugPrint("LibraryViewModel: 새로고침 실패: 예상치 못한 오류 \(error)")
    }
    isRefreshing = false
  }
}
