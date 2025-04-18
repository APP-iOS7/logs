//
//  AlbertosApp.swift
//  Albertos
//
//  Created by Jungman Bae on 4/15/25.
//

import SwiftUI
import HippoAnalytics

// AppDelegate 에서 애널리틱스 초기화
class AppDelegate: NSObject, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize analytics here
    debugPrint("🦛 HippoAnalytics: AppDelegate didFinishLaunchingWithOptions")
    let analytics = HippoAnalytics.shared
    analytics.configure(apiKey: "your_api_key_here")

    return true
  }
}


@main
struct AlbertosApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
