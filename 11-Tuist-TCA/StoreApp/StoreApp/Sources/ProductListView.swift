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
        List(store.products) { product in
          HStack {
            AsyncImage(url: URL(string: product.image)) { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            } placeholder: {
              ProgressView()
            }
            VStack(alignment: .leading) {
              Text(product.title)
                .font(.headline)
              Text("$\(product.price, specifier: "%.2f")")
                .font(.subheadline)
            }
          }
        }
        .navigationTitle("Products")
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
