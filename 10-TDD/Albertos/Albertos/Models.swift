//
//  Models.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import Foundation

struct MenuItem {
    let category: String
    let name: String
}

struct MenuSection {
    let category: String
    let items: [MenuItem]
}

func groupMenuByCategory(_ menu: [MenuItem]) -> [MenuSection] {
    guard menu.isEmpty == false else { return [] }
    return Dictionary(grouping: menu, by: { $0.category })
        .map { category, items in
            MenuSection(category: category, items: items)
        }
        .sorted { $0.category > $1.category }
}
