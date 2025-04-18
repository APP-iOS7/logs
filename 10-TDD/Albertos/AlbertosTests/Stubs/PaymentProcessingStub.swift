//
//  PaymentProcessingSpy.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/18/25.
//
@testable import Albertos
import Combine

class PaymentProcessingStub: PaymentProcessing {
  var result: Result<Void, Error>

  init(returning result: Result<Void, Error>) {
    self.result = result
  }

  func process(for order: Order) -> AnyPublisher<Void, Error> {
    return result.publisher.eraseToAnyPublisher()
  }
}
