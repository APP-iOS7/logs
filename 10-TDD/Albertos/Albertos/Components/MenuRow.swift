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
    HStack {
      Text(viewModel.text)
      Spacer()
      Text("$\(viewModel.price, specifier: "%.2f")")
    }
  }
}

extension MenuRow {
  struct ViewModel {
    let text: String
    let price: Double

    init(item: MenuItem) {
      self.text = item.spicy ? "\(item.name) 🌶️" : item.name
      self.price = item.price
    }
  }
}
