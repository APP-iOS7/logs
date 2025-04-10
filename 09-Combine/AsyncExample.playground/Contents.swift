import Foundation

// 고객과 샌드위치 제작자의 메시지 출력 함수
public func customerSays(_ message: String) {
  print("[고객] \(message)")
}

public func sandwichMakerSays(_ message: String, waitFor time: UInt32 = 0) {
  print("[샌드위치 제작자] \(message)")
  if time > 0 {
    print("                 ... \(time)초 걸립니다")
    sleep(time)
  }
}

// 비동기적으로 빵을 토스트하는 함수
func toastBread(_ bread: String) async -> String {
  sandwichMakerSays("빵을 토스트하는 중... 기다리는 중...")
  try? await Task.sleep(nanoseconds: 5_000_000_000) // 5초 대기
  return "바삭한 \(bread)"
}

// 비동기적으로 재료를 자르는 함수
func slice(_ ingredients: [String]) async -> [String] {
  var result = [String]()
  for ingredient in ingredients {
    sandwichMakerSays("\(ingredient) 자르는 중")
    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
    result.append("자른 \(ingredient)")
  }
  return result
}

// 비동기적으로 샌드위치를 만드는 함수
func makeSandwich(bread: String, ingredients: [String], condiments: [String]) async -> String {
  sandwichMakerSays("샌드위치 준비 중...")

  // 빵 토스트와 재료 자르기를 병렬로 실행
  async let toasted = toastBread(bread)
  async let sliced = slice(ingredients)

  sandwichMakerSays("\(await toasted)에 \(condiments.joined(separator: ", "))를 바르는 중")
  sandwichMakerSays("\(await sliced.joined(separator: ", "))를 올리는 중")
  sandwichMakerSays("상추를 올리는 중")
  sandwichMakerSays("빵 한 조각을 위에 올리는 중")

  return "\(await toasted)에 \(ingredients.joined(separator: ", ")), \(condiments.joined(separator: ", "))"
}

// 메인 프로그램
sandwichMakerSays("카페 비동기식에 오신 것을 환영합니다. 여기서는 주문을 병렬로 처리합니다.")
sandwichMakerSays("주문하세요.")

// 실행 시간 측정
let clock = ContinuousClock()

Task {
  let time = await clock.measure {
    let sandwich = await makeSandwich(bread: "호밀빵", ingredients: ["오이", "토마토"], condiments: ["마요네즈", "머스타드"])
    customerSays("음.... 이 \(sandwich) 샌드위치 정말 맛있어 보이네요!")
  }
  print("이 샌드위치를 만드는 데 \(time) 걸렸습니다")
}

// 프로그램이 종료되지 않도록 잠시 대기
try await Task.sleep(nanoseconds: 10_000_000_000)
