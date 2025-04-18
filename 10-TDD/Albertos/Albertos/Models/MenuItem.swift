//
//  MenuItem.swift
//  Albertos
//
//  Created by Jungman Bae on 4/18/25.
//

struct MenuItem: Identifiable, Equatable, Decodable {

  struct Category: Equatable, Decodable {
    let name: String
  }

  enum CodingKeys: String, CodingKey {
    case name, category, spicy, price
  }

  private enum CategoryKeys: String, CodingKey {
    case name
  }

  let category: String
  let name: String
  let spicy: Bool
  let price: Double

  var id: String { name }

  init(
    category: String,
    name: String,
    spicy: Bool,
    price: Double
  ) {
    self.category = category
    self.name = name
    self.spicy = spicy
    self.price = price
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    if let categoryString = try? container.decode(String.self, forKey: .category) {
      self.category = categoryString
    } else {
      // 중첩된 객체 형식
      let categoryContainer = try container.nestedContainer(keyedBy: CategoryKeys.self, forKey: .category)
      category = try categoryContainer.decode(String.self, forKey: .name)
    }


    self.name = try container.decode(String.self, forKey: .name)
    self.spicy = try container.decode(Bool.self, forKey: .spicy)
    self.price = try container.decode(Double.self, forKey: .price)
  }
}
