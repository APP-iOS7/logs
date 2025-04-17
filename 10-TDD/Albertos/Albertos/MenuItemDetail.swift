//
//  MenuItemDetail.swift
//  Albertos
//
//  Created by Jungman Bae on 4/17/25.
//

import SwiftUI
import Combine

struct MenuItemDetail: View {
  @StateObject var viewModel: ViewModel

  var body: some View {
    VStack {
      Text(viewModel.item.name)
        .font(.largeTitle)
        .padding()

      Text(viewModel.item.category)
        .padding()

      Text(viewModel.item.spicy ? "🌶️" : "")

      Text("$\(viewModel.item.price, specifier: "%.2f")")
        .font(.title)
        .padding()

      Spacer()

      Button(action: {
        viewModel.addOrRemoveFromOrder()
      }) {
        Text(viewModel.orderButtonText)
          .font(.headline)
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
      .padding()
      .navigationTitle("\(viewModel.item.name) 상세")
    }
  }
}

extension MenuItemDetail {
  class ViewModel: ObservableObject {
    let item: MenuItem
    let orderController: OrderController

    @Published private(set) var orderButtonText: String = "주문 삭제"

    private var cancellables = Set<AnyCancellable>()

    init(item: MenuItem, orderController: OrderController = OrderController()) {
      self.item = item
      self.orderController = orderController
      setupOrderButtonPublisher()
    }

    func setupOrderButtonPublisher() {
      self.orderController.$order.sink { [weak self] order in
        guard let self else { return }
        if order.items.contains(self.item) {
          self.orderButtonText = "주문 삭제"
        } else {
          self.orderButtonText = "주문 추가"
        }
      }
      .store(in: &cancellables)
    }

    func addOrRemoveFromOrder() {
      if orderController.isItemInOrder(item) {
        orderController.removeFromOrder(item)
      } else {
        orderController.addToOrder(item)
      }
    }
  }
}

#Preview {
  MenuItemDetail(
    viewModel: MenuItemDetail.ViewModel(
      item: menu[0],
      orderController: OrderController()
    )
  )
}
