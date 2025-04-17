//
//  MenuFetcherTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/17/25.
//
@testable import Albertos
import XCTest
import Combine

final class MenuFetcherTests: XCTestCase {

  var cancellables: Set<AnyCancellable>!

  override func setUpWithError() throws {
    super.setUp()
    cancellables = []
  }

  override func tearDownWithError() throws {
    cancellables = []
    super.tearDown()
  }

  // 요청 성공시 디코드 된 메뉴 아이템이 발행되는지 테스트
  func testWhenRequestSucceedsPublishesDecodedMenuItems() throws {
    let json = """
[
    { "name": "a name", "category": { "name": "a category"}, "spicy": true, "price": 0.00 },
    { "name": "another name", "category": { "name": "a category"}, "spicy": true, "price": 0.00 }
]
"""
    let data = try XCTUnwrap(json.data(using: .utf8))
    let menuFetcher = MenuFetcher(networkFetching: NetworkFetchingStub(returning: .success(data)))

    let expectation = XCTestExpectation(description: "Publishes decoded [MenuItem]")
    menuFetcher.fetchMenu()
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { items in
          XCTAssertEqual(items.count, 2)
          XCTAssertEqual(items.first?.name, "a name")
          XCTAssertEqual(items.last?.name, "another name")
          expectation.fulfill()
        }
      )
      .store(in: &cancellables)
    wait(for: [expectation], timeout: 1)
  }


  // 요청 실패시 에러가 발행되는지 테스트
  func testWhenRequestFailsPublishesReceivedError() {
    let expectedError = URLError(.badServerResponse)
    let menuFetcher = MenuFetcher(networkFetching: NetworkFetchingStub(returning: .failure(expectedError)))
    let expectation = XCTestExpectation(description: "Publishes received URLError")
    menuFetcher.fetchMenu()
      .sink(
        receiveCompletion: { completion in
          guard case .failure(let error) = completion else { return }
          XCTAssertEqual(error as? URLError, expectedError)
          expectation.fulfill()
        },
        receiveValue: { items in
          XCTFail("Expected to fail, succeeded with \(items)")
        }
      )
      .store(in: &cancellables)
    wait(for: [expectation], timeout: 1)

  }

}
