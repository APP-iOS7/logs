import ComposableArchitecture
import SwiftUI

public struct ContentView: View {
  // StoreOf는 특정 Feature의 Store임을 명시
  let store: StoreOf<CounterFeature>

  public var body: some View {
    VStack {
      Text("Count: \(store.count)") // State 직접 접근 (ObservableState 덕분)
        .font(.largeTitle)
        .padding()

      HStack {
        Button("-") {
          store.send(.decrementButtonTapped) // Action 전송
        }
        .font(.largeTitle)
        .padding()

        Button("+") {
          store.send(.incrementButtonTapped) // Action 전송
        }
        .font(.largeTitle)
        .padding()
      }

      // 예시: 로딩 및 결과 표시
      if store.isLoading {
        ProgressView()
          .padding()
      }

      if let fact = store.fact {
        Text(fact)
          .padding()
          .multilineTextAlignment(.center)
      }

      Button("Get Number Fact") {
        store.send(.factButtonTapped)
      }
      .padding()
    }
    .navigationTitle("Counter") // 필요시 네비게이션 타이틀 설정
  }
}

#Preview {
  ContentView(
    store: Store(initialState: CounterFeature.State()) {
      CounterFeature()
      // Preview용 의존성 주입 (예: testValue 사용)
        .dependency(\.numberFact, .previewValue)
        ._printChanges() // 상태 변화 로그 출력 (디버깅용)
    }
  )
}
