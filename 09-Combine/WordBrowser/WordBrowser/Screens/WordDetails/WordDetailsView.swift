//
//  WordDetailView.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

struct WordDetailsView: View {
  let wordToFetch: String
  @State var viewModel: WordDetailsViewModel = WordDetailsViewModel()

  var body: some View {
    List {
      if viewModel.isLoading && viewModel.wordResult == nil { // 초기 로드 시에만 로딩 표시
        ProgressView("\(wordToFetch) 상세 정보 로딩 중...")
      } else if let wordDetail = viewModel.wordResult {
        // 단어 헤더
        Section("단어") {
          Text(wordDetail.word).font(.largeTitle)
          if let pronunciation = wordDetail.pronunciation?.all {
            Text("발음: \(pronunciation)")
              .font(.subheadline)
              .foregroundColor(.gray)
          }
        }

        // 정의 섹션
        if let results = wordDetail.results, !results.isEmpty {
          Section("의미") {
            ForEach(results) { result in
              VStack(alignment: .leading, spacing: 5) {
                if let definition = result.definition {
                  Text(definition)
                }
                if let partOfSpeech = result.partOfSpeech {
                  Text("(\(partOfSpeech))")
                    .font(.footnote)
                    .italic()
                    .foregroundColor(.purple)
                }
                if let examples = result.examples, !examples.isEmpty {
                  VStack(alignment: .leading) {
                    Text("예시:").font(.caption).bold()
                    ForEach(examples, id: \.self) { example in
                      Text("• \(example)")
                        .font(.caption)
                    }
                  }.padding(.leading, 10)
                }
                if let synonyms = result.synonyms, !synonyms.isEmpty {
                  Text("동의어: \(synonyms.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding(.top, 2)
                }

              }
              .padding(.vertical, 4) // 정의 사이에 패딩 추가
            }
          }
        } else if !viewModel.isLoading { // 로딩 중이 아닐 때만 "찾을 수 없음" 표시
          Text("이 단어에 대한 정의를 찾을 수 없습니다.")
            .foregroundColor(.secondary)
        }

      } else if let errorMessage = viewModel.errorMessage {
        Text("상세 정보 로딩 오류: \(errorMessage)")
          .foregroundColor(.red)
      } else {
        // 로딩 중이 아니고 결과/오류가 없는 경우 발생해서는 안 되지만, 좋은 대체 표시
        Text("검색할 단어를 입력하세요.")
          .foregroundColor(.secondary)
      }
    }
    .navigationTitle(viewModel.wordResult?.word ?? wordToFetch) // 가져온 단어 또는 원래 용어 표시
    .navigationBarTitleDisplayMode(.inline)
    // .task를 사용하여 뷰가 나타날 때 데이터 가져오기
    .task {
      await viewModel.fetchWordDetails(for: wordToFetch)
    }
    // 선택 사항: 여기에도 새로고침 기능 추가?
    .refreshable {
      await viewModel.fetchWordDetails(for: wordToFetch)
    }
  }
}
