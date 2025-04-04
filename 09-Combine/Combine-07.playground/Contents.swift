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
  @Published var status: OrderStatus = .placing
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

//// Publisher
//
//// 주문 생성
//let pizzaOrder = Order()
//
//// 주문 상태 변경을 게시
//let pizzaOrderPublisher = NotificationCenter.default.publisher(for: .didUpdateOrderStatus,
//                                                               object: pizzaOrder)
//
//// Subscriber
//
//// 주문 상태 변경을 구독
////pizzaOrderPublisher.sink { notification in
////  print("Notification received: \(notification)")
////
////  // object에서 Order를,
////  // userInfo에서 status를 가져와 주문 상태 업데이트
////  if let orderObject = notification.object as? Order,
////     let statusInfo = notification.userInfo?["status"] as? OrderStatus {
////    orderObject.status = statusInfo
////    print("주문 상태가 업데이트되었습니다: \(pizzaOrder.status)")
////  }
////}.store(in: &cancellables)  // 구독을 cancellables에 저장
//
//// 데이터 변환 및 할당
//pizzaOrderPublisher
//  .compactMap { $0.userInfo?["status"] as? OrderStatus }
//  .assign(to: \.status, on: pizzaOrder)
//  .store(in: &cancellables)
//
//// 주문 상태 변화 모니터링 (디버깅 print 로그를 대체)
//pizzaOrder.$status
//  .dropFirst() // 초기값 제외
//  .sink { status in
//    print("주문 상태가 변경됨: \(status)")
//  }
//  .store(in: &cancellables)
//
//// 초기 상태 출력
//print("초기 주문 상태: \(pizzaOrder.status)")
//
//print("주문 상태를 변경합니다...")
//NotificationCenter
//  .default
//  .post(name: .didUpdateOrderStatus,
//        object: pizzaOrder,
//        userInfo: ["status": OrderStatus.placing])
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//  // 주문 상태 변경
//  print("주문 상태를 변경합니다...")
//  NotificationCenter
//    .default
//    .post(name: .didUpdateOrderStatus,
//          object: pizzaOrder,
//          userInfo: ["status": OrderStatus.placed])
//
//  // 상태 변경 확인
//  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//    print("최종 주문 상태: \(pizzaOrder.status)")
//  }
//}

let margheritaOrder = Order(toppings: [Topping("Tomato Sauce", isVegan: true),
                                       Topping("Vegan Mozzarella", isVegan: true),
                                       Topping("Basil", isVegan: true)])

let extraToppingPublisher = NotificationCenter.default.publisher(for: .addTopping,
                                                                 object: margheritaOrder)

// 비건 토핑을 추가하는 Subscriber
extraToppingPublisher
// userInfo에서 "extra" 키를 사용하여 Topping을 가져옴
  .compactMap { $0.userInfo?["extra"] as? Topping }
// Topping이 비건인지 확인
  .filter { $0.isVegan }
// 최대 3개까지 비건 토핑을 허용
  .prefix(3)
// Topping을 추가하는 작업
  .sink { value in
    if margheritaOrder.toppings != nil {
      margheritaOrder.toppings?.append(value)
      print("비건 토핑 추가됨: \(value.name)")
      print("토핑 개수: \(margheritaOrder.toppings?.count ?? 0)")
      print("현재 비건 토핑 목록: \(margheritaOrder.toppings?.map { $0.name } ?? [])")
    }
  }

NotificationCenter
  .default
  .post(name: .addTopping,
        object: margheritaOrder,
        userInfo: ["extra": Topping("Olives", isVegan: true)])

// 비건이 아닌 토핑 추가
NotificationCenter
  .default
  .post(name: .addTopping,
        object: margheritaOrder,
        userInfo: ["extra": Topping("Pepperoni", isVegan: false)])

NotificationCenter
  .default
  .post(name: .addTopping,
        object: margheritaOrder,
        userInfo: ["extra": Topping("Mushrooms", isVegan: true)])
