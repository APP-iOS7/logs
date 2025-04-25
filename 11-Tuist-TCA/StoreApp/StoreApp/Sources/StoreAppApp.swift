import SwiftUI
import ComposableArchitecture

@main
struct StoreAppApp: App {
  let store = Store(
    initialState: ProductListFeature.State(),
    reducer: {
      ProductListFeature()
        .dependency(\.apiClient, .liveValue)
}  )

  var body: some Scene {
    WindowGroup {
        ProductListView(store: store)
    }
  }
}
