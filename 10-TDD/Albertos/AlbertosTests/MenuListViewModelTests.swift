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
  var cancellables = Set<AnyCancellable>()

  // 메뉴 리스트 첫 Publisher 는 빈 리스트를 발행한다.
  func testWhenFetchingStartsPublishesEmptyMenu() throws {
    try XCTSkipIf(true, "MenuListViewModelTests: testWhenFetchingStartsPublishesEmptyMenu")
    let sut = MenuList.ViewModel(
      menuFetching: MenuFetchingPlaceholder()
    )

    let expectation = XCTestExpectation(description: "Empty menu list")

    let cancellable = sut.$sections
      .dropFirst()
      .sink { sections in
        XCTAssertEqual(sections, [])
        expectation.fulfill()
      }

    wait(for: [expectation], timeout: 1.0)
    cancellable.cancel()
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
        // Ensure the grouping closure is called with
        // the received menu
        XCTAssertEqual(receivedMenu,  expectedMenu)
        // Ensure the published value is the result of
        // the grouping closure
        XCTAssertEqual(value, expectedSections)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    wait(for: [expectation], timeout: 1)
  }

  // 메뉴 리스트 조회가 실패하면, 에러를 발행한다.
  func testWhenFetchingFailsPublishesAnError() {}
}
