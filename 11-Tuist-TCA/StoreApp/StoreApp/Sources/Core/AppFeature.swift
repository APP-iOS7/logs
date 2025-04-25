//
//  AppFeature.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {

  @ObservableState
  struct State: Equatable {
    var productList: ProductListFeature.State
    var productDetail: ProductDetailFeature.State
    var cart: CartFeature.State
    var selectedProduct: Product? = nil // 선택된 상품 추적
  }

  enum Action {
    case productList(ProductListFeature.Action)
    case productDetail(ProductDetailFeature.Action)
    case cart(CartFeature.Action)
    case selectProduct(Product?) // 상품 선택 액션 추가
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.productList, action: \.productList) {
      ProductListFeature()
    }

    Scope(state: \.productDetail, action: \.productDetail) {
      ProductDetailFeature()
    }

    Scope(state: \.cart, action: \.cart) {
      CartFeature()
    }

    Reduce { state, action in
      switch action {
      case .selectProduct(let product):
        state.selectedProduct = product
        // 상품 선택 시 ProductDetail 상태 업데이트
        if let product = product {
          state.productDetail.product = product
          state.productDetail.quantity = 1 // 초기 수량 리셋
        }
        return .none
      case .productDetail(.addToCart(let item)):
        return .send(.cart(.addItem(item)))
      default:
        return .none
      }
    }
  }
}
