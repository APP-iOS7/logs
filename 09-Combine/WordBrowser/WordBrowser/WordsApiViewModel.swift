//
//  WordsApiViewModel.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

@Observable
class WordsApiViewModel {
  var searchTerm: String = ""
  var wordResult: Word? = nil
  var isLoading: Bool = false
  var errorMessage: String? = nil

  // WordDetailsView의 .task에서 사용
  func fetchWordDetails(for word: String) async {
    // 이미 로드되었거나 현재 로딩 중이면 가져오기 방지
    if isLoading || wordResult?.word == word { return }

    debugPrint("상세 정보 가져오기: \(word)")
    isLoading = true
    errorMessage = nil
    // 여기서 wordResult를 지울지 여부? 로딩 중에 이전 결과를 계속 보여줄까? 지우자.
    // self.wordResult = nil

    do {
      let result = try await APIClient.search(for: word)
      self.wordResult = result
      debugPrint("\(word) 상세 정보 가져오기 성공")
    } catch let error as WordsAPIError {
      self.errorMessage = error.localizedDescription
      debugPrint("\(word) 상세 정보 가져오기 실패: \(error.localizedDescription)")
    } catch {
      self.errorMessage = "예상치 못한 오류 발생: \(error.localizedDescription)"
      debugPrint("\(word) 상세 정보 가져오기 실패: 예상치 못한 오류 \(error)")
    }
    isLoading = false
  }

}
