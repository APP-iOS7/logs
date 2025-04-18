//
//  OrderButton.swift
//  Albertos
//
//  Created by Jungman Bae on 4/18/25.
//

import SwiftUI
import Combine

struct OrderButton: View {
  @StateObject private var viewModel: ViewModel

  init(orderController: OrderController) {
    _viewModel = StateObject(wrappedValue: ViewModel(orderController: orderController))
  }

  var body: some View {
    NavigationLink(value: "OrderDetail") {
      Text(viewModel.buttonText)
    }
  }
}

extension OrderButton {
  class ViewModel: ObservableObject {

    @Published var buttonText: String = "주문하기"

    let orderController: OrderController

    private var cancellables = Set<AnyCancellable>()

    init(orderController: OrderController) {
      self.orderController = orderController
      setupOrderButtonPublisher()
    }

    private func setupOrderButtonPublisher() {
      orderController.$order
        .sink { [weak self] order in
          guard let self = self else { return }
          if order.items.isEmpty {
            self.buttonText = "주문 목록"
          } else {
            self.buttonText = "주문 목록 (\(order.items.count))"
          }
        }
        .store(in: &cancellables)

    }
  }
}
