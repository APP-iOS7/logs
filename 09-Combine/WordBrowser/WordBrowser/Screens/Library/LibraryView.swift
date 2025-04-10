//
//  LibraryView.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

struct LibraryView: View {
  @State var viewModel = LibraryViewModel()

  var body: some View {
    NavigationStack {
      List {
        // 새로고침으로 가져온 랜덤 단어 섹션
        if let word = viewModel.randomWord {
          Section("랜덤 단어") {
            // 랜덤 단어도 탐색 가능하게 만들기
            NavigationLink(value: word.word) {
              VStack(alignment: .leading) {
                Text(word.word).font(.headline)
                if let firstDef = word.results?.first?.definition {
                  Text(firstDef)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                }
              }
            }
            if let error = viewModel.refreshError {
              Text("랜덤 단어 로딩 오류: \(error)")
                .foregroundColor(.red)
                .font(.caption)
            }
          }
        } else if viewModel.isRefreshing {
          Section { ProgressView() } // 명시적으로 새로고침할 때만 로딩 표시
        } else if let error = viewModel.refreshError {
          Section("랜덤 단어") {
            Text("랜덤 단어 로딩 오류: \(error)")
              .foregroundColor(.red)
          }
        }

        // TODO: 추가적인 섹션을 여기에 추가할 수 있습니다.
      }
      .navigationTitle("라이브러리")
      .refreshable { // 당겨서 새로고침 추가
        print("UI에서 새로고침 시작됨")
        await viewModel.refresh()
        print("UI에서 새로고침 완료됨")
      }
      .navigationDestination(for: String.self) { word in
        WordDetailsView(wordToFetch: word)
      }

    }
  }
}
