import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// 구독 취소 방지를 위해 Cancellable을 저장할 집합
var cancellables = Set<AnyCancellable>()

// 주문 상태를 나타내는 열거형
enum OrderStatus {
  case placing
  case processing
  case placed
  case shipping
  case delivered
}

// 주소 상태를 나타내는 열거형
enum AddressStatus {
  case valid
  case invalid
}

// 피자 토핑을 나타내는 클래스
class Topping {
  let name: String
  let isVegan: Bool

  init(_ name: String, isVegan: Bool) {
    self.name = name
    self.isVegan = isVegan
  }
}

// 피자 주문을 나타내는 클래스
class Order {
  var status: OrderStatus = .placing
  var toppings: [Topping]?

  init(toppings: [Topping]? = nil) {
    self.toppings = toppings
  }
}

// NotificationCenter에서 사용할 알림 이름 확장
extension Notification.Name {
  static let didUpdateOrderStatus = Notification.Name("didUpdateOrderStatus")
  static let didValidateAddress = Notification.Name("didValidateAddress")
  static let addTopping = Notification.Name("addTopping")
}

// Publisher

// 주문 생성
let pizzaOrder = Order()

// 주문 상태 변경을 게시
let pizzaOrderPublisher = NotificationCenter.default.publisher(for: .didUpdateOrderStatus,
                                                               object: pizzaOrder)

// Subscriber

// 주문 상태 변경을 구독
pizzaOrderPublisher.sink { notification in
  print("Notification received: \(notification)")

  // userInfo에서 status를 가져와 주문 상태 업데이트
  if let orderObject = notification.object as? Order,
     let statusInfo = notification.userInfo?["status"] as? OrderStatus {
    orderObject.status = statusInfo
    print("주문 상태가 업데이트되었습니다: \(pizzaOrder.status)")
  }
}.store(in: &cancellables)  // 구독을 cancellables에 저장



DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
  // 주문 상태 변경
  print("주문 상태를 변경합니다...")
  NotificationCenter
    .default
    .post(name: .didUpdateOrderStatus,
          object: pizzaOrder,
          userInfo: ["status": OrderStatus.processing])

  // 상태 변경 확인
  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    print("최종 주문 상태: \(pizzaOrder.status)")
  }
}

print("주문 상태가 변경되었습니다: \(pizzaOrder.status)")
