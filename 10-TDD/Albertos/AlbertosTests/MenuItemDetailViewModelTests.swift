//
//  MenuItemDetailViewModelTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/17/25.
//
@testable import Albertos
import XCTest

// 메뉴 상세 페이지의 뷰모델 상태 값을 테스트 합니다.
final class MenuItemDetailViewModelTests: XCTestCase {

  // 메뉴가 장바구니에 담겨있으면, 주문 버튼은 "주문 삭제"를 표시해야 합니다.
  func testWhenItemIsInOrderButtonSaysRemove() {
    // Arrange
    let item = MenuItem.fixture()
    let orderController = OrderController()
    let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)
    let text = viewModel.orderButtonText

    // Act
    orderController.addToOrder(item: item)

    // Assert
    XCTAssertEqual(text, "주문 삭제")
  }

  // 메뉴가 장바구니에 담겨있지 않으면, 주문 버튼은 "주문 추가"를 표시해야 합니다.
  func testWhenItemIsNotInOrderButtonSaysAdd() {}

  // 메뉴가 장바구니에 담겨있으면, 주문 버튼을 누르면 장바구니에서 삭제됩니다.
  func testWhenItemIsInOrderButtonActionRemovesIt() {}

  // 메뉴가 장바구니에 담겨있지 않으면, 주문 버튼을 누르면 장바구니에 추가됩니다.
  func testWhenItemIsNotInOrderButtonActionAddsIt() {}
}
