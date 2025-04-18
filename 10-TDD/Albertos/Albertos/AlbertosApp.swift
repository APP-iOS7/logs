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
        VStack {
          MenuList(viewModel: .init(
            menuFetching: MenuFetcher()
          ))
          OrderButton(orderController: orderController)
        }
        .navigationDestination(for: String.self) { destination in
          if destination == "OrderDetail" {
            OrderDetail(orderController: orderController)
          }
        }
      }
      .environmentObject(orderController)
    }
  }
}
