//
//  ProductListFeature.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProductListFeature {
  @ObservableState
  struct State: Equatable {
    var products: IdentifiedArrayOf<Product> = []
    var isLoading = false
    var error: String? = nil
  }

  enum Action {
    case onAppear
    case productsResponse(Result<[Product], Error>)
  }

  @Dependency(\.apiClient) var apiClient

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        debugPrint("Fetching products...")
        state.isLoading = true
        return .run { send in
          do {
            let products = try await apiClient.fetchProducts()
            await send(.productsResponse(.success(products)))
          } catch {
            await send(.productsResponse(.failure(error)))
          }
        }

      case let .productsResponse(.success(products)):
        state.products = IdentifiedArray(uniqueElements: products)
        state.isLoading = false
        return .none

      case let .productsResponse(.failure(error)):
        state.error = "데이터 로딩 실패: \(error.localizedDescription)"
        state.isLoading = false
        return .none
      }
    }
  }

}
