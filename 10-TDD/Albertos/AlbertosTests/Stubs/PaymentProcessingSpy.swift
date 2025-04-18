//
//  PaymentProcessingSpy.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/18/25.
//
@testable import Albertos
import Combine

class PaymentProcessingSpy: PaymentProcessing {
  var receivedOrder: Order?

  func process(for order: Order) -> AnyPublisher<Void, Error> {
    receivedOrder = order
    return Result<Void, Error>.success(()).publisher.eraseToAnyPublisher()
  }
}
