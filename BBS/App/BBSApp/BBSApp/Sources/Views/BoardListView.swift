//
//  BoardListView.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI

struct BoardListView: View {
  @StateObject private var viewModel = BoardListViewModel()

  var body: some View {
    NavigationView {
      Group {
        if viewModel.isLoading {
          ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
          Text("Error: \(errorMessage)")
        } else {
          List(viewModel.boards) { board in
            if let boardId = board.id {
              NavigationLink(destination: PostListView(boardId: boardId, boardName: board.name)) {
                Text(board.name)
              }
            } else {
              Text(board.name)
            }
          }
        }
      }
      .navigationTitle("Boards")
      .task { //.onAppear 대신.task 사용 권장 (async/await 지원)
        await viewModel.fetchBoards()
      }
      .refreshable {
        await viewModel.fetchBoards()
      }
    }
  }
}

#Preview {
  BoardListView()
}
