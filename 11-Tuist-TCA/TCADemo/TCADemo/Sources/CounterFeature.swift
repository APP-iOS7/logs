//
//  CounterFeature.swift
//  TCADemo
//
//  Created by Jungman Bae on 4/24/25.
//

import ComposableArchitecture

@Reducer
struct CounterFeature {
  // MARK: - State
  @ObservableState
  struct State: Equatable {
    var count = 0
  }
  
  // MARK: - Action
  enum Action {
    case incrementButtonTapped
    case decrementButtonTapped
  }
  
  // MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .incrementButtonTapped:
        state.count += 1
        return .none
        
      case .decrementButtonTapped:
        state.count -= 1
        return .none
        
      }
    }
  }
}
