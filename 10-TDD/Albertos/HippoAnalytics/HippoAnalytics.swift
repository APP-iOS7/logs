//
//  HippoAnalytics.swift
//  HippoAnalytics
//
//  Created by Jungman Bae on 4/18/25.
//

import Foundation

public class HippoAnalytics {
  public static let shared = HippoAnalytics()
  private init() {}

  var apiKey: String?

  public func configure(apiKey: String) {
    self.apiKey = apiKey
  }

  public func logEvent(named name: String, properties: [String: Any]? = .none) {
    guard let apiKey = apiKey else {
      debugPrint("🦛 HippoAnalytics: API key not configured.")
      return
    }

    debugPrint("apiKey: \(apiKey)")

    if let properties = properties {
      debugPrint("🦛 HippoAnalytics: Logged event named '\(name)' with properties '\(properties)'")
    } else {
      debugPrint("🦛 HippoAnalytics: Logged event named '\(name)'")
    }
  }
}
