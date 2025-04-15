//
//  Models.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import Foundation

struct MenuItem: Identifiable {
  let category: String
  let name: String

  var id: String {
    name
  }
}

struct MenuSection: Identifiable {
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
  MenuItem(category: "starters", name: "Caprese Salad"),
  MenuItem(category: "starters", name: "Arancini Balls"),
  MenuItem(category: "pastas", name: "Penne all'Arrabbiata"),
  MenuItem(category: "pastas", name: "Spaghetti Carbonara"),
  MenuItem(category: "drinks", name: "Water"),
  MenuItem(category: "drinks", name: "Red Wine"),
  MenuItem(category: "desserts", name: "Tiramisù"),
  MenuItem(category: "desserts", name: "Crema Catalana"),
]
