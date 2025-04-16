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
  func testWhenFetchingFailsPublishesAnError() {}
}
