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
  }

  enum Action {
    case productList(ProductListFeature.Action)
    case productDetail(ProductDetailFeature.Action)
    case cart(CartFeature.Action)
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
  }
}
