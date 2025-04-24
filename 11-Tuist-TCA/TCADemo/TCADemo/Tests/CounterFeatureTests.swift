@testable import TCADemo

import ComposableArchitecture
import Testing

@MainActor
struct CounterFeatureTests {
  @Test
  func basics() async {
    let store = TestStore(initialState: CounterFeature.State()) {
      CounterFeature()
    }

    await store.send(.incrementButtonTapped) { state in
      state.count = 1
    }
    await store.send(.decrementButtonTapped) {
      $0.count = 0
    }
  }
}
