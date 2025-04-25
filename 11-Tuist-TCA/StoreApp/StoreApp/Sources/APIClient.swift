//
//  APIClient.swift
//  StoreApp
//
//  Created by Jungman Bae on 4/25/25.
//

import Dependencies
import Foundation

struct APIClient {
  let fetchProducts: () async throws -> [Product]
}

extension APIClient: DependencyKey {
  static let liveValue = APIClient(
    fetchProducts: {
      let url = URL(string: "https://fakestoreapi.com/products")!
      let (data, _) = try await URLSession.shared.data(from: url)
      return try JSONDecoder().decode([Product].self, from: data)
    }
  )

  static let previewValue = APIClient(
    fetchProducts: {
      [
        Product(id: 1, title: "Product 1", price: 10.0, description: "Description 1", category: "Category 1", image: "Image URL 1"),
        Product(id: 2, title: "Product 2", price: 20.0, description: "Description 2", category: "Category 2", image: "Image URL 2")
      ]
    }
  )

  static let testValue = APIClient(
    fetchProducts: {
      throw NSError(domain: "MockError", code: 1, userInfo: nil)
    }
  )
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

private enum APIClientKey: DependencyKey {
  static let liveValue = APIClient.liveValue
  static let previewValue = APIClient.previewValue
  static let testValue = APIClient.testValue
}
