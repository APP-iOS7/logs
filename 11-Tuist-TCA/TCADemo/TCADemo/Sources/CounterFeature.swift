//
//  CounterFeature.swift
//  TCADemo
//
//  Created by Jungman Bae on 4/24/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CounterFeature {
  // MARK: - State
  @ObservableState
  struct State: Equatable {
    var count = 0
    var isLoading = false
    var fact: String?
    var isTimerRunning = false
  }

  // MARK: - Action
  enum Action {
    case incrementButtonTapped
    case decrementButtonTapped
    case factButtonTapped
    case factResponse(String)
    case toggleTimerButtonTapped
    case timerTick
  }

  enum CancelID { case timer }

  // MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .incrementButtonTapped:
        state.count += 1
        state.fact = nil
        return .none

      case .decrementButtonTapped:
        state.count -= 1
        state.fact = nil
        return .none

      case .factButtonTapped:
        return handleFactButtonTapped(&state)

      case let .factResponse(fact):
        state.fact = fact
        state.isLoading = false
        return .none

      case .toggleTimerButtonTapped:
        return handleTimerButtonTapped(&state)

      case .timerTick:
        state.count += 1
        state.fact = nil
        return .none
      }
    }
  }

  private func handleFactButtonTapped(_ state: inout CounterFeature.State) -> Effect<CounterFeature.Action> {
    state.fact = nil
    state.isLoading = true

    return .run { [count = state.count] send in
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
      let fact = String(decoding: data, as: UTF8.self)
      await send(.factResponse(fact))
    }
  }

  private func handleTimerButtonTapped(_ state: inout CounterFeature.State) -> Effect<CounterFeature.Action> {
    state.isTimerRunning.toggle()
    if state.isTimerRunning {
      return .run { [isRunning = state.isTimerRunning] send in
        while true {
          try await Task.sleep(for: .seconds(1))
          await send(.timerTick)
          if !isRunning {
            break
          }
        }
      }
      .cancellable(id: CancelID.timer)
    } else {
      return .cancel(id: CancelID.timer)
    }
  }

}
