//
//  ContentView.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import SwiftUI
import Combine

struct MenuList: View {
  @StateObject var viewModel: ViewModel

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

    var cancellables = Set<AnyCancellable>()

    init(
      menuFetching: MenuFetching,
      menuGrouping: @escaping ([MenuItem]) -> [MenuSection] = groupMenuByCategory) {
        self.sections = []
        menuFetching.fetchMenu()
          .sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] items in
              self?.sections = menuGrouping(items)
            })
          .store(in: &cancellables)
      }
  }
}

#Preview {
  NavigationStack {
    MenuList(viewModel: .init(menuFetching: MenuFetchingPlaceholder()))
  }
}
