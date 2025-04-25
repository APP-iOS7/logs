//
//  ProductListView.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import SwiftUI
import ComposableArchitecture

struct ProductListView: View {
  let store: StoreOf<ProductListFeature>
  
  var body: some View {
    Group {
      if store.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if let error = store.error {
        Text("Error: \(error)")
          .foregroundColor(.red)
          .padding()
      } else if store.products.isEmpty {
        Text("No products available")
          .padding()
      } else {
        NavigationStack {
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
                }
            )
          }
        }
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  NavigationView {
    ProductListView(
      store: Store(initialState: ProductListFeature.State()) {
        ProductListFeature()
      }
    )
  }
}
