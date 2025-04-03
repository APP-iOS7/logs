//
//  ContentView.swift
//  PowerfulSwiftUI
//
//  Created by Jungman Bae on 4/3/25.
//

import SwiftUI

struct LazyGridExample: View {
  let rows = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    ScrollView(.horizontal) {
      LazyHGrid(rows: rows, spacing: 20) {
        ForEach(0..<50) { index in
          Text("Item \(index)")
            .frame(width: 150)
            .frame(maxHeight: .infinity)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
        }
      }
      .padding()
    }
  }
}

struct ContentView: View {
    var body: some View {
        LazyGridExample()
    }
}



#Preview {
    ContentView()
}
