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
  }

  enum Action {
    case loadProductDetails
    case productDetailsLoaded(Result<Product, Error>)
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
      }
    }
  }
}
