//
//  MenuItemDetail.swift
//  Albertos
//
//  Created by Jungman Bae on 4/17/25.
//

import SwiftUI

struct MenuItemDetail: View {
  var body: some View {
    VStack {
      EmptyView()
    }
  }
}

extension MenuItemDetail {
  struct ViewModel {
    let item: MenuItem
    let orderController: OrderController

    var orderButtonText: String {
      "주문 삭제"
    }

    init(item: MenuItem, orderController: OrderController = OrderController()) {
      self.item = item
      self.orderController = orderController
    }
  }
}
