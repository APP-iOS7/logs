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

      Button(action: {
        viewModel.checkout()
      }) {
        Text("결제하기")
          .font(.headline)
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
    }
    .navigationTitle("주문 상세")
    .alert(viewModel.alertToShow?.title ?? "",
           isPresented: $viewModel.showAlert,
           actions: {
      Button(viewModel.alertToShow?.buttonText ?? "확인", role: .cancel) {
        viewModel.showAlert = false
      }
    }, message: {
      Text(viewModel.alertToShow?.message ?? "")
    })
  }
}

extension OrderDetail {
  class ViewModel: ObservableObject {
    let orderController: OrderController

    @Published private(set) var orderItems: [MenuItem] = []
    @Published private(set) var totalPrice: Double = 0.0
    @Published private(set) var alertToShow: Alert.ViewModel?
    @Published var showAlert: Bool = false

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
          receiveCompletion: { [weak self] value in
            guard case .failure(let error) = value else { return }
            // 실패 얼럿
            self?.alertToShow = Alert.ViewModel(
              title: "결제 실패",
              message: error.localizedDescription,
              buttonText: "확인"
            )
            self?.showAlert = true
          },
          receiveValue: { [weak self] paymentResult in
            print("Payment result: \(paymentResult)")
            // 성공 얼럿
            self?.alertToShow = Alert.ViewModel(
              title: "결제 성공",
              message: "결제가 완료되었습니다.",
              buttonText: "확인"
            )
            self?.showAlert = true
          })
        .store(in: &cancellables)
    }
  }
}
