import Foundation

// 타겟 함수
func fizzBuzz(_ number: Int) -> String {
  if number % 3 == 0 {
    return "fizz"
  }
  return ""
}

// 테스트 함수
func testFizzBuzz() {
  print("FizzBuzz 테스트 시작")
  print("FizzBuzz(1): \(fizzBuzz(1) == "1" ? "PASS" : "FAIL")")
  print("FizzBuzz(2): \(fizzBuzz(2) == "2" ? "PASS" : "FAIL")")
  print("FizzBuzz(3): \(fizzBuzz(3) == "fizz" ? "PASS" : "FAIL")")
  print("FizzBuzz(5): \(fizzBuzz(5) == "buzz" ? "PASS" : "FAIL")")
  print("FizzBuzz(15): \(fizzBuzz(15) == "fizz-buzz" ? "PASS" : "FAIL")")
  print("FizzBuzz 테스트 완료")
}

testFizzBuzz()
