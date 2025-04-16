//
//  ContentView.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import SwiftUI

struct MenuList: View {
  let viewModel: ViewModel
  
  var body: some View {
    List {
      ForEach(viewModel.sections) { section in
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

extension MenuList {
  class ViewModel: ObservableObject {
    @Published private(set) var sections: [MenuSection]
    
    init(
      menuFetching: MenuFetching,
      menuGrouping: @escaping ([MenuItem]) -> [MenuSection]) {
        self.sections = menuGrouping([])
      }
  }
}

#Preview {
  NavigationStack {
    MenuList(viewModel: .init(menuFetching: MenuFetchingPlaceholder(),
                              menuGrouping: groupMenuByCategory))
  }
}
