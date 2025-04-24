@testable import TCADemo

import ComposableArchitecture
import Testing

@MainActor
struct CounterFeatureTests {
  @Test
  func testIncrementDecrementButtonWorks() async {
    // Arrage
    let store = TestStore(initialState: CounterFeature.State()) {
      CounterFeature()
    }

    // Act
    await store.send(.incrementButtonTapped) { state in
      // Assert
      state.count = 1
    }

    // Act
    await store.send(.decrementButtonTapped) {
      // Assert
      $0.count = 0
    }
  }
}
