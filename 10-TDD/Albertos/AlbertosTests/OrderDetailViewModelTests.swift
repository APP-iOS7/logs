//
//  OrderDetailViewModelTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/18/25.
//
@testable import Albertos
import XCTest
import HippoPayments

final class OrderDetailViewModelTests: XCTestCase {

  func testWhenCheckoutButtonTappedStartsPaymentProcessingFlow() {
    // OrderController를 생성하고 일부 항목을 추가합니다.
    let orderController = MockOrderController()
    orderController.addToOrder(.fixture(name: "name"))
    orderController.addToOrder(.fixture(name: "other name"))
    // 스파이를 생성합니다.
    let paymentProcessingSpy = PaymentProcessingSpy()
    let viewModel = OrderDetail.ViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy
    )
    viewModel.checkout()
    XCTAssertEqual(paymentProcessingSpy.receivedOrder, orderController.order)
  }

  func testWhenPaymentFailsUpdatesPropertyToShowErrorAlert() {
    let viewModel = OrderDetail.ViewModel(
      orderController: OrderController(),
      paymentProcessor: PaymentProcessingStub(
        returning: .failure(HippoPaymentsError.genericError)
      )
    )
    let predicate = NSPredicate { _,_ in viewModel.alertToShow != nil }
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: .none)
    viewModel.checkout()
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(viewModel.alertToShow?.title,"결제 실패")
    XCTAssertEqual(
      viewModel.alertToShow?.message, "The operation couldn’t be completed. (HippoPayments.HippoPaymentsError error 0.)"
    )
    XCTAssertEqual(viewModel.alertToShow?.buttonText, "확인")
  }

  func testWhenPaymentSucceedsDismissingTheAlertRunsTheGivenClosure() {
    let viewModel = OrderDetail.ViewModel(
      orderController: OrderController(),
      paymentProcessor: PaymentProcessingStub(returning: .success(()))
    )
    let predicate = NSPredicate { _,_ in viewModel.alertToShow != nil }
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: .none)
    viewModel.checkout()
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(viewModel.alertToShow?.title,"결제 성공")
  }

}
