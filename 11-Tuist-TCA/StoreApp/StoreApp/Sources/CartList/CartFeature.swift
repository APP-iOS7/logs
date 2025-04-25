//
//  CartFeature.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CartFeature {

    @ObservableState
    struct State: Equatable {
      var items: [CartItem] = []
      var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
      }
    }

    enum Action {
      case addItem(CartItem)
      case removeItem(UUID)
      case updateQuantity(UUID, Int)
    }

    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        case .addItem(let item):
          if state.items.contains(where: { $0.productId == item.productId }) {
            // 이미 장바구니에 있는 경우 수량만 업데이트
            if let index = state.items.firstIndex(where: { $0.productId == item.productId }) {
              state.items[index].quantity += item.quantity
            }
          } else {
            // 장바구니에 없는 경우 새로 추가
            state.items.append(item)
          }
          return .none

        case .removeItem(let id):
          state.items.removeAll { $0.id == id }
          return .none

        case .updateQuantity(let id, let quantity):
          if let index = state.items.firstIndex(where: { $0.id == id }) {
            state.items[index].quantity = quantity
          }
          return .none
        }
      }
    }
}
