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
      switch viewModel.sections {
      case .success(let sections):
        ForEach(sections) { section in
          Section(header: Text(section.category)) {
            ForEach(section.items) { item in
              MenuRow(viewModel: .init(item: item))
            }
          }
        }
      case .failure(let error):
        Text("An error occurred:")
        Text(error.localizedDescription).italic()
      }
    }
    .navigationTitle("Alberto's 🇮🇹")
  }
}

extension MenuList {
  class ViewModel: ObservableObject {
    @Published private(set) var sections: Result<[MenuSection], Error> = .success([])

    var cancellables = Set<AnyCancellable>()

    init(
      menuFetching: MenuFetching,
      menuGrouping: @escaping ([MenuItem]) -> [MenuSection] = groupMenuByCategory) {
        menuFetching.fetchMenu()
          .sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] items in
              debugPrint("Fetched \(items.count) menu items")
              self?.sections = .success(menuGrouping(items))
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
