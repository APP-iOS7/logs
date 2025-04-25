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
              ProductDetailView(
                store: Store(
                  initialState: ProductDetailFeature.State(product: product)) {
                    ProductDetailFeature()
                      ._printChanges()
                }
              )
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

#Preview {
  NavigationView {
    ProductListView(
      store: Store(initialState: ProductListFeature.State()) {
        ProductListFeature()
          ._printChanges()
      }
    )
  }
}
