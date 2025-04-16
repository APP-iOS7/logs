//
//  MenuRow.swift
//  Albertos
//
//  Created by Jungman Bae on 4/16/25.
//

import SwiftUI

struct MenuRow: View {
  let viewModel: ViewModel

  var body: some View {
    Text(viewModel.text)
  }
}

extension MenuRow {
  struct ViewModel {
    let text: String

    init(item: MenuItem) {
      self.text = item.spicy ? "\(item.name) 🌶️" : item.name
    }
  }
}
