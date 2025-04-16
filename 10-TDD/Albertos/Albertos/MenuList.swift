//
//  ContentView.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import SwiftUI

struct MenuList: View {
  let sections: [MenuSection]

  var body: some View {
    List {
      ForEach(sections) { section in
        Section(header: Text(section.category)) {
          ForEach(section.items) { item in
            MenuRow(viewModel: .init(item: item))
          }
        }
      }
    }
    .navigationTitle("Alberto's 🇮🇹")
  }
}

#Preview {
  NavigationStack {
    MenuList(sections: groupMenuByCategory(menu))
  }
}
