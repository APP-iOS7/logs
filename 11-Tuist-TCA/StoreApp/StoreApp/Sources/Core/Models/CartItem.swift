//
//  CartItem.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import Foundation

struct CartItem: Identifiable, Equatable, Codable {
  let id: UUID
  let productId: Product.ID
  var quantity: Int
  let product: Product

  var totalPrice: Double {
    return product.price * Double(quantity)
  }
}
