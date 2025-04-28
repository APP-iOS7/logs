//
//  BoardListView.swift
//  BBSApp
//
//  Created by Jungman Bae on 4/28/25.
//

import SwiftUI

struct BoardListView: View {
  @EnvironmentObject var authViewModel: AuthViewModel

  @StateObject private var viewModel = BoardListViewModel()

  var body: some View {
    NavigationStack {
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
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            // 로그아웃 액션
            authViewModel.signOut()
          }) {
            Text("로그아웃")
          }
        }
        if authViewModel.isAdmin  {
          ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink(destination: CreateBoardView()) {
              Text("게시판 생성")
            }
          }
        }
      }
    }
  }
}

#Preview {
  BoardListView()
}
