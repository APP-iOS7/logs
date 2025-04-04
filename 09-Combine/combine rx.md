# Combine의 Subscriber를 Rx 패턴 용어로 설명

Combine 프레임워크와 ReactiveX(Rx) 패턴은 반응형 프로그래밍이라는 같은 패러다임을 다른 방식으로 구현한 것입니다. Rx에 익숙한 개발자가 Combine을 이해하기 쉽도록 Combine의 Subscriber 개념을 Rx 패턴의 용어로 설명해 드리겠습니다.

## Combine의 Subscriber와 Rx 패턴의 개념 비교

| Combine 용어 | Rx 패턴 용어 | 설명 |
|-------------|------------|------|
| Subscriber | Observer | 데이터 스트림을 구독하고 이벤트를 수신하는 객체 |
| Publisher | Observable | 시간에 따라 값을 방출하는 데이터 스트림 |
| sink | subscribe | 스트림을 구독하고 값을 처리하는 메서드 |
| receiveValue | onNext | 새 값이 방출될 때 호출되는 콜백 |
| receiveCompletion(.finished) | onCompleted | 스트림이 정상적으로 종료될 때 호출되는 콜백 |
| receiveCompletion(.failure) | onError | 오류가 발생할 때 호출되는 콜백 |

## Rx 패턴에서의 Subscriber(Observer) 설명

Rx 패턴에서 Combine의 Subscriber는 **Observer**에 해당합니다. Observer는 Observable(Publisher와 동등)이 방출하는 이벤트를 수신하고 반응하는 객체입니다.

### Rx의 Observer 주요 콜백

1. **onNext**: 새 값이 방출될 때마다 호출됨 (Combine의 `receiveValue`와 동일)
2. **onCompleted**: 모든 값 방출이 완료되어 스트림이 정상 종료될 때 호출됨 (Combine의 `receiveCompletion(.finished)`와 동일)
3. **onError**: 오류가 발생하여 스트림이 종료될 때 호출됨 (Combine의 `receiveCompletion(.failure)`와 동일)

### Rx에서 Observer 생성 예제와 Combine 비교

**RxSwift 예제:**

```swift
// Rx 패턴
let observable = Observable.of(1, 2, 3, 4, 5)

observable.subscribe(
    onNext: { value in
        print("값 받음: \(value)")
    },
    onCompleted: {
        print("완료됨")
    },
    onError: { error in
        print("오류 발생: \(error)")
    }
)
```

**동등한 Combine 코드:**

```swift
// Combine
let publisher = [1, 2, 3, 4, 5].publisher

publisher.sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("완료됨")
        case .failure(let error):
            print("오류 발생: \(error)")
        }
    },
    receiveValue: { value in
        print("값 받음: \(value)")
    }
)
```

## Rx 패턴에서 자주 사용되는 Observer 유형과 Combine 비교

### 1. subscribe / sink

**Rx:**

- `observable.subscribe(onNext: { value in ... })`

**Combine:**

- `publisher.sink(receiveValue: { value in ... })`

### 2. bind / assign

**Rx:**

- `observable.bind(to: textField.rx.text)`

**Combine:**

- `publisher.assign(to: \.text, on: textField)`

### 3. 연산자 체이닝

**Rx:**

```swift
observable
    .filter { $0 > 0 }
    .map { $0 * 2 }
    .subscribe(onNext: { value in ... })
```

**Combine:**

```swift
publisher
    .filter { $0 > 0 }
    .map { $0 * 2 }
    .sink(receiveValue: { value in ... })
```

### 4. DisposeBag / Cancellable

**Rx:**

```swift
let disposeBag = DisposeBag()
observable.subscribe(...).disposed(by: disposeBag)
```

**Combine:**

```swift
var cancellables = Set<AnyCancellable>()
publisher.sink(...).store(in: &cancellables)
```

## 핵심 차이점

1. **메모리 관리:**
   - Rx: `DisposeBag`을 사용
   - Combine: `AnyCancellable` 객체를 저장하거나 유지

2. **오류 처리:**
   - Rx: `onNext`, `onError`, `onCompleted`가 별도 메서드
   - Combine: `receiveValue`와 `receiveCompletion`으로 구분되며, 완료는 `.finished`와 `.failure` 두 가지 케이스로 나뉨

3. **명명법:**
   - Rx: Observer, Observable, subscribe
   - Combine: Subscriber, Publisher, sink/assign

Rx 패턴에 익숙하다면, Combine의 개념은 이름만 다를 뿐 근본적인 아이디어와 사용 패턴은 매우 유사합니다. 두 프레임워크 모두 스트림 기반의 비동기 이벤트 처리를 위한 선언적 API를 제공합니다.

---

# Combine 연산자를 Rx 패턴 용어로 설명

Combine과 ReactiveX(Rx) 패턴은 모두 풍부한 연산자(Operator) 세트를 제공합니다. 두 프레임워크의 연산자들은 대부분 동일한 기능을 하지만 이름이 약간 다른 경우가 있습니다. Rx 패턴에 익숙한 개발자를 위해 주요 Combine 연산자와 해당하는 Rx 연산자를 비교해 보겠습니다.

## 변환 연산자 (Transforming Operators)

| Combine 연산자 | Rx 연산자 | 설명 |
|--------------|----------|------|
| map | map | 각 요소를 변환 |
| compactMap | compactMap (Swift), filter + map (RxSwift) | nil을 제거하고 옵셔널 해제 |
| flatMap | flatMap | 중첩된 Publisher/Observable을 평탄화 |
| replaceNil | map | nil 값을 기본값으로 대체 |
| scan | scan | 누적 결과 생성 |
| setFailureType | - | 실패 유형 설정 |
| collect | toArray | 요소를 배열로 수집 |

## 필터링 연산자 (Filtering Operators)

| Combine 연산자 | Rx 연산자 | 설명 |
|--------------|----------|------|
| filter | filter | 조건에 맞는 요소만 통과 |
| removeDuplicates | distinctUntilChanged | 연속 중복 제거 |
| compactMap | filter + map | nil을 제거하고 옵셔널 해제 |
| replaceEmpty | defaultIfEmpty | 빈 스트림에 기본값 제공 |
| replaceError | catchErrorJustReturn | 오류를 기본값으로 대체 |
| retry | retry | 오류 발생 시 재시도 |
| first | first | 첫 번째 요소만 방출 |
| last | last | 마지막 요소만 방출 |
| dropFirst | skip | 처음 n개 요소 건너뛰기 |
| drop(while:) | skipWhile | 조건이 거짓이 될 때까지 건너뛰기 |
| prefix | take | 처음 n개 요소만 가져오기 |
| prefix(while:) | takeWhile | 조건이 참일 동안만 요소 가져오기 |

## 결합 연산자 (Combining Operators)

| Combine 연산자 | Rx 연산자 | 설명 |
|--------------|----------|------|
| merge | merge | 여러 스트림 병합 |
| combineLatest | combineLatest | 각 스트림의 최신 값 결합 |
| zip | zip | 동일한 인덱스의 요소를 쌍으로 결합 |
| prepend | startWith | 스트림 시작 부분에 값 추가 |
| append | concat | 스트림 끝 부분에 값 추가 |
| switchToLatest | switchLatest | 가장 최근 스트림으로 전환 |

## 시간 관련 연산자 (Time Operators)

| Combine 연산자 | Rx 연산자 | 설명 |
|--------------|----------|------|
| debounce | debounce | 지정된 시간 동안 새 이벤트가 없을 때만 방출 |
| throttle | throttle | 주어진 시간 간격으로 방출 제한 |
| delay | delay | 지정된 시간만큼 이벤트 지연 |
| timeout | timeout | 지정된 시간 내에 이벤트가 없으면 오류 발생 |
| measureInterval | timeInterval | 이벤트 간 시간 간격 측정 |

## 오류 처리 연산자 (Error Handling Operators)

| Combine 연산자 | Rx 연산자 | 설명 |
|--------------|----------|------|
| catch | catchError | 오류를 새로운 Publisher로 대체 |
| replaceError | catchErrorJustReturn | 오류를 기본값으로 대체 |
| retry | retry | 오류 발생 시 지정된 횟수만큼 재시도 |
| assertNoFailure | - | 오류가 발생하면 앱 충돌 (디버깅용) |

## 디버깅 연산자 (Debugging Operators)

| Combine 연산자 | Rx 연산자 | 설명 |
|--------------|----------|------|
| breakpoint | - | 조건에 따라 중단점 설정 |
| handleEvents | do | 이벤트 발생 시 부가 작업 수행 |
| print | debug | 로그 출력 |

## Rx 패턴의 연산자 사용 예제와 Combine 비교

### 1. map 연산자

**RxSwift:**

```swift
Observable.of(1, 2, 3)
    .map { $0 * 2 }
    .subscribe(onNext: { print($0) })
```

**Combine:**

```swift
[1, 2, 3].publisher
    .map { $0 * 2 }
    .sink { print($0) }
```

### 2. filter와 map 조합

**RxSwift:**

```swift
Observable.of(1, 2, 3, 4, 5)
    .filter { $0 % 2 == 0 }
    .map { $0 * 10 }
    .subscribe(onNext: { print($0) })
```

**Combine:**

```swift
[1, 2, 3, 4, 5].publisher
    .filter { $0 % 2 == 0 }
    .map { $0 * 10 }
    .sink { print($0) }
```

### 3. 오류 처리

**RxSwift:**

```swift
someObservable
    .catchError { error -> Observable<Int> in
        return Observable.just(-1)
    }
    .subscribe(onNext: { print($0) })
```

**Combine:**

```swift
somePublisher
    .catch { error -> Just<Int> in
        return Just(-1)
    }
    .sink { print($0) }
```

### 4. combineLatest

**RxSwift:**

```swift
Observable.combineLatest(observable1, observable2) { value1, value2 in
    return value1 + value2
}
```

**Combine:**

```swift
publisher1.combineLatest(publisher2)
    .map { value1, value2 in
        return value1 + value2
    }
```

## 핵심 차이점

1. **명명법:**
   - 대부분의 연산자가 유사한 이름을 가지지만, 일부는 다릅니다.
   - Rx의 `startWith`는 Combine에서 `prepend`
   - Rx의 `toArray`는 Combine에서 `collect`

2. **체이닝 구문:**
   - 둘 다 유사한 체이닝 구문을 사용하지만, Combine은 Swift 표준 라이브러리와 더 밀접하게 통합됩니다.

3. **Marble 다이어그램:**
   - Rx는 연산자 동작을 설명하기 위한 마블 다이어그램을 광범위하게 사용
   - Combine도 유사한 시각화를 사용하지만, 공식 문서에서는 덜 강조됨

Rx 패턴에 익숙하다면, 대부분의 Combine 연산자는 매우 유사하게 작동하므로 쉽게 전환할 수 있습니다. 가장 큰 차이는 명명법과 Swift 표준 라이브러리와의 통합 방식입니다.
