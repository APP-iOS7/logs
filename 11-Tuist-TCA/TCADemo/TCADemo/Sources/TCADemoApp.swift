import ComposableArchitecture
import SwiftUI

@main
struct TCADemoApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: CounterFeature.State()) {
          CounterFeature()
            .dependency(\.numberFact, .liveValue) // Preview용 의존성 주입
        }
      )
    }
  }
}
