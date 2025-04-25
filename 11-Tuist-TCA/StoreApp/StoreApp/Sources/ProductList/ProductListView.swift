//
//  ProductListView.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import SwiftUI
import ComposableArchitecture

struct ProductListView: View {
  @Bindable var store: StoreOf<ProductListFeature>
  let appStore: StoreOf<AppFeature> // 부모 스토어 참조 추가

  var body: some View {
    NavigationStack {
      Group {
        WithPerceptionTracking {
          if store.isLoading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else if let error = store.error {
            Text("Error: \(error)")
              .foregroundColor(.red)
              .padding()
              .refreshable {
                store.send(.onAppear)
              }
          } else if store.products.isEmpty {
            Text("No products available")
              .padding()
          } else {
            List(store.products) { product in
              NavigationLink(value: product, label: {
                ProductRow(product: product)
              })
            }
            .navigationTitle("Products")
            .navigationDestination(for: Product.self) { product in
              WithPerceptionTracking {
                // 상품 선택 시 AppFeature에 선택된 상품 전달
                let _ = appStore.send(.selectProduct(product))

                ProductDetailView(
                  store: appStore.scope(
                    state: \.productDetail,
                    action: \.productDetail
                  )
                )
              }
            } // NavigationDestination
            .refreshable {
              store.send(.onAppear)
            }
          } // if/else
        } // WithPerceptionTracking
      } // Group
    } // NavigationStack
    .onAppear {
      store.send(.onAppear)
    }
  } // body
}
