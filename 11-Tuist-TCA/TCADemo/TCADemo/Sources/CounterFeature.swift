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
  @ObservableState // SwiftUI 뷰에서 관찰 가능하도록 설정
  struct State: Equatable { // 테스트 용이성을 위해 Equatable 채택
    var count = 0
    var isLoading = false // 예시: 로딩 상태 추가
    var fact: String? = nil // 예시: API 결과 저장
  }

  // MARK: - Action
  enum Action {
    case incrementButtonTapped
    case decrementButtonTapped
    // 예시: 비동기 작업을 위한 액션 추가
    case factButtonTapped
    case factResponse(Result<String, Error>) // Result 사용 예시
  }

  // MARK: - Dependencies (TCA의 의존성 관리 시스템 활용 예시)
  @Dependency(\.continuousClock) var clock // 시간 관련 의존성
  @Dependency(\.numberFact) var numberFact // API 클라이언트 의존성

  // MARK: - Reducer Body
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case.incrementButtonTapped:
        state.count += 1
        state.fact = nil // 카운트 변경 시 이전 fact 제거
        return.none // 이 액션은 부수 효과 없음

      case.decrementButtonTapped:
        state.count -= 1
        state.fact = nil // 카운트 변경 시 이전 fact 제거
        return.none // 이 액션은 부수 효과 없음

      case.factButtonTapped:
        state.isLoading = true
        state.fact = nil
        // EffectTask를 반환하여 API 호출 등 비동기 작업 수행
        // TCA 1.0에서는 EffectTask<Output> 사용 권장 (실패 불가능 시)
        // 실패 가능 시 EffectPublisher<Output, Error> 사용
        return.run { [count = state.count] send in
          // 의존성 주입된 numberFact 클라이언트 사용
          let fact = try await self.numberFact.fetch(count)
          await send(.factResponse(.success(fact)))
        } catch: { error, send in
          // 에러 처리
          await send(.factResponse(.failure(error)))
        }

      case let.factResponse(.success(fact)):
        state.isLoading = false
        state.fact = fact
        return.none

      case.factResponse(.failure):
        state.isLoading = false
        // 에러 상태 처리 (예: 사용자에게 알림 표시)
        return.none
      }
    }
  }

}
