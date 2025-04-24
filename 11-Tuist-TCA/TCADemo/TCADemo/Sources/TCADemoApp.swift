import ComposableArchitecture
import SwiftUI

@main
struct TCADemoApp: App {
  static let store = Store(initialState: CounterFeature.State()) {
    CounterFeature()
  }

  var body: some Scene {
    WindowGroup {
      ContentView(store: TCADemoApp.store)
    }
  }
}
