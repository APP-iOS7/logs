//
//  OrderDetail.swift
//  Albertos
//
//  Created by Jungman Bae on 4/18/25.
//

import SwiftUI

struct OrderDetail: View {
  @StateObject private var viewModel: ViewModel
  
  init(orderController: OrderController) {
    _viewModel = StateObject(wrappedValue: ViewModel(orderController: orderController))
  }
  
  var body: some View {
    List {
      // TODO: 주문 목록을 보여주는 UI
    }
    .navigationTitle("주문 상세")
  }
}

extension OrderDetail {
  class ViewModel: ObservableObject {
    let orderController: OrderController
    
    init(orderController: OrderController) {
      self.orderController = orderController
    }
  }
}
