//
//  MenuFetchingStub.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/16/25.
//
@testable import Albertos
import Foundation
import Combine

class MenuFetchingStub: MenuFetching {
  let result: Result<[MenuItem], Error>

  init(returning result: Result<[MenuItem], Error>) {
    self.result = result
  }

  func fetchMenu() -> AnyPublisher<[MenuItem], Error> {
    return Future { $0(self.result) }
      .delay(for: 0.1, scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
