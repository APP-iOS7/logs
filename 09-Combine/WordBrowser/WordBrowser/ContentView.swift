//
//  ContentView.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      TabView {
        LibraryView()
          .tabItem {
            Label("라이브러리", systemImage: "books.vertical")
          }

        WordSearchView()
          .tabItem {
            Label("API 검색", systemImage: "magnifyingglass")
          }
      }
    }
}

#Preview {
    ContentView()
}
