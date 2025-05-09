import SwiftUI
import ComposableArchitecture

@main
struct StoreApp: App {
  let store = Store(
    initialState: AppFeature.State(
      productList: ProductListFeature.State(),
      productDetail: ProductDetailFeature.State(),
      cart: CartFeature.State()),
  ) {
    AppFeature()
  }

  var body: some Scene {
    WindowGroup {
      ProductListView(
        store: store.scope(state: \.productList, action: \.productList),
        appStore: store
      )
    }
  }
}
