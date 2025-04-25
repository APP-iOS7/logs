//
//  ProductDetailFeature.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProductDetailFeature {

  @ObservableState
  struct State: Equatable {
    var product: Product?
    var isLoading: Bool = false
    var error: String?
    var quantity: Int = 1
  }

  enum Action {
    case loadProductDetails
    case productDetailsLoaded(Result<Product, Error>)
    case addToCart(CartItem)
    case quantityChanged(Int) // 추가: 수량 변경
    case addToCartButtonTapped // 추가: 장바구니 버튼 탭
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loadProductDetails:
        state.isLoading = true
        return .none

      case .productDetailsLoaded(let result):
        state.isLoading = false
        switch result {
        case .success(let product):
          state.product = product
          return .none
        case .failure(let error):
          state.error = error.localizedDescription
          return .none
        }
      case .addToCart:
        return .none

      case .quantityChanged(let quantity):
        state.quantity = max(1, quantity) // 최소 수량은 1
        return .none
        
      case .addToCartButtonTapped:
        guard let product = state.product else { return .none }
        let cartItem = CartItem(
          id: UUID(),
          productId: product.id,
          quantity: state.quantity,
          product: product
        )
        return .send(.addToCart(cartItem))

      }

      
    }
  }
}
