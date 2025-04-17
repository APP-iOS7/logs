//
//  OrderController.swift
//  Albertos
//
//  Created by Jungman Bae on 4/17/25.
//

import Foundation
import Combine

class OrderController: ObservableObject {
  @Published private(set) var order: Order

  init(order: Order = Order(items: [])) {
    self.order = order
  }

  func isItemInOrder(_ item: MenuItem) -> Bool {
    return order.items.contains { $0.id == item.id }
  }

  func addToOrder(_ item: MenuItem) {
    order.items.append(item)
  }

  func removeFromOrder(_ item: MenuItem) {
    order.items.removeAll { $0.id == item.id }
  }
}
