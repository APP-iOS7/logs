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
          debugPrint("Adding item: \(item)")
          state.items.append(item)
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
