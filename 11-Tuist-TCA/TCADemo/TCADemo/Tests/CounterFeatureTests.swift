@testable import TCADemo

import ComposableArchitecture
import Testing

@MainActor
struct CounterFeatureTests {
  let store: TestStore<CounterFeature.State, CounterFeature.Action>

  init() throws {
    store = TestStore(initialState: CounterFeature.State()) {
      CounterFeature()
    }
  }

  @Test
  func testIncrementButtonWorks() async {
    // Act
    await store.send(.incrementButtonTapped) { state in
      // Assert
      state.count = 1
    }
  }

  @Test
  func testDecrementButtonWorks() async {
    // Act
    await store.send(.decrementButtonTapped) {
      // Assert
      $0.count = -1
    }
  }

}
