//
//  OrderDetail.swift
//  Albertos
//
//  Created by Jungman Bae on 4/18/25.
//

import SwiftUI
import Combine
import HippoPayments

struct OrderDetail: View {
  @StateObject private var viewModel: ViewModel
  
  init(orderController: OrderController) {
    _viewModel = StateObject(wrappedValue: ViewModel(orderController: orderController))
  }
  
  var body: some View {
    List {
      ForEach(viewModel.orderItems) { item in
        HStack {
          Text(item.name)
            .font(.headline)
          Spacer()
          Text("$\(item.price, specifier: "%.2f")")
            .foregroundColor(.gray)
        }
      }

      Section(header: Text("총 가격")) {
        Text("$\(viewModel.totalPrice, specifier: "%.2f")")
          .font(.headline)
      }
    }
    .navigationTitle("주문 상세")
  }
}

extension OrderDetail {
  class ViewModel: ObservableObject {
    let orderController: OrderController

    @Published private(set) var orderItems: [MenuItem] = []
    @Published private(set) var totalPrice: Double = 0.0

    private let paymentProcessor: PaymentProcessing

    private var cancellables = Set<AnyCancellable>()

    init(
      orderController: OrderController,
      paymentProcessor: PaymentProcessing = HippoPaymentsProcessor(apiKey: "your_api_key_here")
    ) {
      self.orderController = orderController
      self.paymentProcessor = paymentProcessor

      setupSubscriptions()
    }

    private func setupSubscriptions() {
      orderController.$order
        .sink { [weak self] order in
          guard let self = self else { return }
          self.orderItems = order.items
          self.totalPrice = order.items.reduce(0) { $0 + $1.price }
        }
        .store(in: &cancellables)
    }

    func checkout() {
      paymentProcessor.process(for: orderController.order)
        .sink(
          receiveCompletion: { _ in },
          receiveValue: { paymentResult in
            print("Payment result: \(paymentResult)")
        })
        .store(in: &cancellables)
    }
  }
}
