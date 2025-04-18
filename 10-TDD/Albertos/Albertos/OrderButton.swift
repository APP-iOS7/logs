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
    Button(action: {
      // 주문 상세 화면으로 이동하는 로직
      viewModel.showOrderDetail.toggle()
    }) {
      Text(viewModel.buttonText)
    }
    .sheet(isPresented: $viewModel.showOrderDetail) {
      OrderDetail(orderController: viewModel.orderController)
    }
  }
}

extension OrderButton {
  class ViewModel: ObservableObject {

    @Published var buttonText: String = "주문하기"
    @Published var showOrderDetail: Bool = false

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
