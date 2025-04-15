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
    let items: [MenuItem]
}

func groupMenuByCategory(_ menu: [MenuItem]) -> [MenuSection] {
    guard menu.isEmpty == false else { return [] }
    return [MenuSection(items: menu)]
}
