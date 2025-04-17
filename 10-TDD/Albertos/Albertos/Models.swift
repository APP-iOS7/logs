//
//  Models.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import Foundation

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



struct MenuSection: Identifiable, Equatable {
  let category: String
  let items: [MenuItem]

  var id: String {
    category
  }
}

func groupMenuByCategory(_ menu: [MenuItem]) -> [MenuSection] {
  guard menu.isEmpty == false else { return [] }
  return Dictionary(grouping: menu, by: { $0.category })
    .map { category, items in
      MenuSection(category: category, items: items)
    }
    .sorted { $0.category > $1.category }
}

// 이 첫 번째 반복에서는 메뉴가 하드 코딩된 배열입니다.
let menu = [
  MenuItem(category: "starters", name: "Caprese Salad", spicy: false, price: 7.99),
  MenuItem(category: "starters", name: "Arancini Balls", spicy: true, price: 8.99),
  MenuItem(category: "pastas", name: "Penne all'Arrabbiata", spicy: true, price: 12.99),
  MenuItem(category: "pastas", name: "Spaghetti Carbonara", spicy: false, price: 13.99),
  MenuItem(category: "drinks", name: "Water", spicy: false, price: 1.99),
  MenuItem(category: "drinks", name: "Red Wine", spicy: false, price: 9.99),
  MenuItem(category: "desserts", name: "Tiramisù", spicy: false, price: 5.99),
  MenuItem(category: "desserts", name: "Crema Catalana", spicy: false, price: 6.99),
]
