//
//  Product.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import Foundation

struct Product: Identifiable, Equatable, Codable {
  let id: Int
  let title: String
  let price: Double
  let description: String
  let category: String
  let image: String
}
