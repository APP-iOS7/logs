//
//  AlbertosApp.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import SwiftUI

@main
struct AlbertosApp: App {
  let orderController = OrderController()

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        MenuList(viewModel: .init(
          menuFetching: MenuFetcher()
        ))
      }
      .environmentObject(orderController)
    }
  }
}
