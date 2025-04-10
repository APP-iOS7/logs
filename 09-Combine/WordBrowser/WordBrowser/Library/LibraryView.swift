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
        
      }
      .navigationTitle("라이브러리")
      .refreshable { // 당겨서 새로고침 추가
        print("UI에서 새로고침 시작됨")
        await viewModel.refresh()
        print("UI에서 새로고침 완료됨")
      }

    }
  }
}
