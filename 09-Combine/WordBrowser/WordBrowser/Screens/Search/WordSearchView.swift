//
//  WordSearchView.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

struct WordSearchView: View {
  @State var viewModel = WordSearchViewModel()
  
  var body: some View {
    // 검색 결과로부터의 향후 내비게이션 가능성을 위해 NavigationStack 사용
    NavigationStack {
      List {
        // 결과 또는 로딩/오류 상태 표시
        if viewModel.isLoading {
          ProgressView("검색 중...")
        } else if let wordResult = viewModel.wordResult {
          // 성공적으로 결과를 얻었음 ('빈' 결과일지라도)
          if wordResult.word == "찾을 수 없음" || wordResult.results == nil || wordResult.results?.isEmpty == true {
            if !viewModel.searchTerm.isEmpty { // 검색이 시도된 경우에만 "찾을 수 없음" 표시
              Text("\"\(viewModel.searchTerm)\"에 대한 결과가 없습니다.")
                .foregroundColor(.secondary)
            } else {
              Text("단어를 입력하고 검색을 누르세요.")
                .foregroundColor(.secondary)
            }
          } else {
            // 찾은 단어와 그 상세 정보를 직접 표시하거나 WordDetailsView로 연결
            // 단순화를 위해 여기서는 기본 정보만 표시하고 연결
            Section("결과") {
              NavigationLink(value: wordResult.word) { // 찾은 단어 문자열을 사용하여 탐색
                VStack(alignment: .leading) {
                  Text(wordResult.word).font(.headline)
                  if let firstDef = wordResult.results?.first?.definition {
                    Text(firstDef)
                      .font(.caption)
                      .foregroundColor(.gray)
                      .lineLimit(1)
                  }
                }
              }
            }
          }
        } else if let errorMessage = viewModel.errorMessage {
          Text("오류: \(errorMessage)")
            .foregroundColor(.red)
        } else {
          Text("위 칸에 단어를 입력하고 검색을 누르세요.")
            .foregroundColor(.secondary)
        }
      }
      .navigationTitle("API 검색")
      // .searchable은 텍스트 변경 시, .onSubmit은 커밋 시 트리거됨
      .searchable(text: $viewModel.searchTerm, prompt: "WordsAPI 검색...")
      .autocapitalization(.none)
      .disableAutocorrection(true)
      // .onSubmit을 사용하여 API 호출 트리거
      .onSubmit(of: .search) { // Return 키 또는 검색 버튼으로 트리거됨
        print("검색 제출됨: \(viewModel.searchTerm)")
        // 비동기 컨텍스트를 만들기 위해 Task {} 사용
        Task {
          await viewModel.executeQuery()
        }
      }
      // 결과 링크 클릭 시 내비게이션 처리
      .navigationDestination(for: String.self) { word in
        WordDetailsView(wordToFetch: word)
      }
    }
  }
}
