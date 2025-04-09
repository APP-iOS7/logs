//
//  ContentView.swift
//  CombineFirebaseBookShelf
//
//  Created by Jungman Bae on 4/9/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("Closure-based APIs")) {
          NavigationLink(destination: OnDemandBookDetailsViewWithClosures()) {
            Label("On-demand fetch a single book", systemImage: "book")
          }
          NavigationLink(destination: OnDemandBookListViewWithClosures()) {
            Label("On-demand fetch list of books", systemImage: "books.vertical")
          }
          NavigationLink(destination: LiveBooksListViewWithClosures()) {
            Label("Live books list", systemImage: "bolt")
          }
        }
        Section(header: Text("Combine-based APIs")) {
          NavigationLink(destination: OnDemandBookDetailsViewWithCombine()) {
            Label("On-demand fetch a single book", systemImage: "book")
          }
          NavigationLink(destination: OnDemandBookListViewWithCombine()) {
            Label("On-demand fetch list of books", systemImage: "books.vertical")
          }
          NavigationLink(destination: LiveBooksListViewWithCombine()) {
            Label("Live books list", systemImage: "bolt")
          }
        }

      }
      .navigationTitle("Book Shelf")
    }
  }
}

#Preview {
  ContentView()
}
