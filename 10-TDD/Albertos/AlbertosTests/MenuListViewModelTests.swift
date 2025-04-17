//
//  MenuListViewModelTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/16/25.
//
@testable import Albertos
import XCTest
import Combine

final class MenuListViewModelTests: XCTestCase {
  var cancellables: Set<AnyCancellable>!

  override func setUpWithError() throws {
    try super.setUpWithError()
    cancellables = []
  }

  override func tearDownWithError() throws {
    cancellables = []
    try super.tearDownWithError()
  }


  // 메뉴 리스트 첫 Publisher 는 빈 리스트를 발행한다.
  func testWhenFetchingStartsPublishesEmptyMenu() throws {
    // Arrange
    let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingStub(returning: .success([])))

    // Act
    let sections = try viewModel.sections.get()

    // Assert
    XCTAssertTrue(sections.isEmpty)
  }

  // 메뉴 리스트 조회가 성공하면, 메뉴를 그룹화하는 클로저를 사용하여 섹션을 생성한다.
  func testWhenFecthingSucceedsPublishesSectionsBuiltFromReceivedMenuAndGivenGroupingClosure() {
    var receivedMenu: [MenuItem]?
    let expectedSections = [MenuSection.fixture()]
    let spyClosure: ([MenuItem]) -> [MenuSection] = { items in
      receivedMenu = items
      return expectedSections
    }
    let expectedMenu = [MenuItem.fixture()]
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingStub(returning: .success(expectedMenu)),
      menuGrouping: spyClosure
)
    let expectation = XCTestExpectation(
      description: "Publishes sections built from received menu and given grouping closure"
    )
    viewModel
      .$sections
      .dropFirst()
      .sink { value in
        guard case .success(let sections) = value else {
          return XCTFail("Expected a successful Result, got: \(value)")
        }
        // Ensure the grouping closure is called with the
        // received menu
        XCTAssertEqual(receivedMenu, expectedMenu)
        // Ensure the published value is the result of the
        // grouping closure
        XCTAssertEqual(sections, expectedSections)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    wait(for: [expectation], timeout: 1)
  }

  // 메뉴 리스트 조회가 실패하면, 에러를 발행한다.
  func testWhenFetchingFailsPublishesAnError() {
    // Arrange
    let expectedError = NSError(domain: "TestError", code: 0, userInfo: nil)
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingStub(returning: .failure(expectedError))
    )

    // Act
    let expectation = XCTestExpectation(description: "Publishes an error")

    viewModel
      .$sections
      .dropFirst()
      .sink { value in
        guard case .failure(let error) = value else {
          return XCTFail("Expected a failing Result, got: \(value)")
        }
        XCTAssertEqual(error as NSError, expectedError)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    // Assert
    wait(for: [expectation], timeout: 1)
  }

  // 메뉴 조회 재시도 테스트
  func testRetryFetchesMenuAgain() throws {
    try XCTSkipIf(true, "skipping this for now, keeping it to reuse part of the code later on")
    // Arrange
    var fetchCount = 0
    let expectedMenu = [MenuItem.fixture()]

    let menuFetchingSpy = MenuFetchingSpy(
      fetchingClosure: {
        fetchCount += 1
        if fetchCount == 1 {
          return Fail(error: NSError(domain: "TestError", code: 0, userInfo: nil))
            .eraseToAnyPublisher()
        } else {
          return Just(expectedMenu)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
      })

    let viewModel = MenuList.ViewModel(menuFetching: menuFetchingSpy)

    // Act
    let firstFailExpectation = XCTestExpectation(description: "First fetch fails")
    let expectation = XCTestExpectation(description: "Retry fetches menu again")

    var results = [Result<[MenuSection], Error>]()
    viewModel
      .$sections
      .sink { value in
        results.append(value)
        guard case .success(let sections) = value else {
          firstFailExpectation.fulfill()
          return
        }
        XCTAssertEqual(sections.flatMap { $0.items }, expectedMenu)
        expectation.fulfill()
      }
      .store(in: &cancellables)


    viewModel.retry()

    // Assert
    wait(for: [firstFailExpectation], timeout: 0.1)
    wait(for: [expectation], timeout: 0.1)
    XCTAssertEqual(fetchCount, 2)
    XCTAssertTrue(results[0].isFailure)
    XCTAssertTrue(results[1].isSuccess)
  }

}

extension Result {
  var isSuccess: Bool {
    switch self {
    case .success: return true
    case .failure: return false
    }
  }
  var isFailure: Bool {
    return !isSuccess
  }
}
