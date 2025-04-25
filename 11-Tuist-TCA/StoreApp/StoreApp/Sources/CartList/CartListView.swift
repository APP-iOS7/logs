//
//  CartListView.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import SwiftUI
import ComposableArchitecture

struct CartListView: View {
  @Bindable var store: StoreOf<CartFeature>

  var body: some View {
    List {
      ForEach(store.items) { item in
        HStack {
          AsyncImage(url: URL(string: item.product.image)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 50, height: 50)
          } placeholder: {
            ProgressView()
          }

          VStack(alignment: .leading) {
            Text(item.product.title)
              .font(.headline)
            Text("$\(item.product.price, specifier: "%.2f") × \(item.quantity)")
              .font(.subheadline)
          }

          Spacer()

          Text("$\(item.totalPrice, specifier: "%.2f")")
            .font(.headline)

          Button(action: {
            store.send(.removeItem(item.id))
          }) {
            Image(systemName: "trash")
              .foregroundColor(.red)
          }
        }
      }

      if !store.items.isEmpty {
        Section {
          HStack {
            Text("Total")
              .font(.headline)
            Spacer()
            Text("$\(store.totalPrice, specifier: "%.2f")")
              .font(.headline)
          }
        }
      }
    }
    .navigationTitle("장바구니")
  }
}
