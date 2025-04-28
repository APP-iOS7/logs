//
//  CreateBoardView.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI

struct CreateBoardView: View {

  @Environment(\.dismiss) private var dismiss

  @StateObject private var viewModel = CreateBoardViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        Text("게시판 생성")
          .font(.largeTitle)
          .padding()

        TextField("게시판 이름", text: $viewModel.boardName)
          .textFieldStyle(.roundedBorder)
          .padding()

        TextField("게시판 설명", text: $viewModel.boardDescription)
          .textFieldStyle(.roundedBorder)
          .padding()

        Button("생성하기") {
          // 게시판 생성 로직
          Task {
            await try? viewModel.createBoard()
            if viewModel.errorMessage == nil {
              dismiss()
            }
          }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
      }
      .padding()
    }
  }
}

#Preview {
  CreateBoardView()
}
