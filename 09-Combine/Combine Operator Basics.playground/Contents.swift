import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// ===== 예제 1: map - 값 변환하기 =====
print("\n1️⃣ map - 값을 다른 형태로 변환하기")
print("----------------------------------")

let numbersPublisher = [1, 2, 3, 4, 5].publisher

// map 연산자: 각 값을 변환합니다 (여기서는 제곱)
let squaredNumbers = numbersPublisher
  .map { number in
    return number * number
  }
  .sink { squaredNumber in
    print("👉 원래 숫자의 제곱: \(squaredNumber)")
  }

// ===== 예제 2: filter - 값 걸러내기 =====
print("\n2️⃣ filter - 조건에 맞는 값만 통과시키기")
print("---------------------------------------")

let mixedNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher

// filter 연산자: 조건에 맞는 값만 통과시킵니다 (여기서는 짝수만)
let evenNumbers = mixedNumbers
  .filter { number in
    return number % 2 == 0  // 짝수만 통과
  } // [2, 4, 6, 8, 10]이 발행됩니다
  .sink { evenNumber in
    print("👉 짝수: \(evenNumber)")
  }
