//
//  ProductDetailView.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import SwiftUI
import ComposableArchitecture

struct ProductDetailView: View {
  @Bindable var store: StoreOf<ProductDetailFeature>

  var body: some View {
    ScrollView {
      if let product = store.product {
        VStack(alignment: .leading) {
          AsyncImage(url: URL(string: product.image)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity, maxHeight: 300)
          } placeholder: {
            ProgressView()
          }
          Text(product.title)
            .font(.largeTitle)
            .padding(.top)
          Text("$\(product.price, specifier: "%.2f")")
            .font(.title2)
            .padding(.top, 5)
          Text(product.description)
            .padding(.top, 10)
        }
        .padding()
      } else if store.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if let error = store.error {
        Text("Error: \(error)")
          .foregroundColor(.red)
          .padding()
      }
    }
    .navigationTitle("Product Details")
  }
}

#Preview {
  NavigationStack {
    ProductDetailView(
      store: Store(
        initialState: ProductDetailFeature.State(product: Product.example)) {
          ProductDetailFeature()
        }
    )
  }
}
