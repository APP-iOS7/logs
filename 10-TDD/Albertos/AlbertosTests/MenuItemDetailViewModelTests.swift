//
//  MenuItemDetailViewModelTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/17/25.
//
@testable import Albertos
import XCTest

class MockOrderController: OrderController {
  var isItemInOrderCalled = false
  var addToOrderCalled = false
  var removeFromOrderCalled = false

  override func isItemInOrder(_ item: MenuItem) -> Bool {
    isItemInOrderCalled = true
    return super.isItemInOrder(item)
  }

  override func addToOrder(_ item: MenuItem) {
    addToOrderCalled = true
    super.addToOrder(item)
  }

  override func removeFromOrder(_ item: MenuItem) {
    removeFromOrderCalled = true
    super.removeFromOrder(item)
  }
}

// 메뉴 상세 페이지의 뷰모델 상태 값을 테스트 합니다.
final class MenuItemDetailViewModelTests: XCTestCase {
  var testItem: MenuItem!
  var viewModel: MenuItemDetail.ViewModel!
  var orderController: MockOrderController!

  override func setUp() {
    super.setUp()
    testItem = .fixture()
    orderController = MockOrderController()
    viewModel = MenuItemDetail.ViewModel(item: testItem, orderController: orderController)
  }

  override func tearDown() {
    viewModel = nil
    orderController = nil
    testItem = nil
    super.tearDown()
  }


  // 메뉴가 장바구니에 담겨있으면, 주문 버튼은 "주문 삭제"를 표시해야 합니다.
  func testWhenItemIsInOrderButtonSaysRemove() {
    // Act
    orderController.addToOrder(testItem)

    // Assert
    XCTAssertEqual(viewModel.orderButtonText, "주문 삭제")
  }

  // 메뉴가 장바구니에 담겨있지 않으면, 주문 버튼은 "주문 추가"를 표시해야 합니다.
  func testWhenItemIsNotInOrderButtonSaysAdd() {
    // Assert
    XCTAssertEqual(viewModel.orderButtonText, "주문 추가")

  }

  // 메뉴가 장바구니에 담겨있으면, 주문 버튼을 누르면 장바구니에서 삭제됩니다.
  func testWhenItemIsInOrderButtonActionRemovesIt() {
    // Act
    orderController.addToOrder(testItem)
    viewModel.addOrRemoveFromOrder()

    // Assert
    XCTAssertFalse(orderController.order.items.contains { $0 == testItem })
  }

  // 메뉴가 장바구니에 담겨있지 않으면, 주문 버튼을 누르면 장바구니에 추가됩니다.
  func testWhenItemIsNotInOrderButtonActionAddsIt() {
    // Act
    viewModel.addOrRemoveFromOrder()

    // Assert
    XCTAssertTrue(orderController.order.items.contains { $0 == testItem })

  }


  func testAddOrRemoveFromOrderAddsItemWhenNotInOrder() {
    viewModel.addOrRemoveFromOrder()
    XCTAssertTrue(orderController.isItemInOrderCalled)
    XCTAssertTrue(orderController.addToOrderCalled)
    XCTAssertFalse(orderController.removeFromOrderCalled)
  }

  func testAddOrRemoveFromOrderRemovesItemWhenInOrder() {
    orderController.addToOrder(testItem)
    viewModel.addOrRemoveFromOrder()
    XCTAssertTrue(orderController.isItemInOrderCalled)
    XCTAssertTrue(orderController.addToOrderCalled)
    XCTAssertTrue(orderController.removeFromOrderCalled)
  }

}
