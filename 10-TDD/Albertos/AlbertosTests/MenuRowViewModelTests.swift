//
//  MenuRowViewModelTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/16/25.
//
@testable import Albertos
import XCTest

final class MenuRowViewModelTests: XCTestCase {
  // 맵지 않은 메뉴는 이름만 출력되는지 테스트
  func testWhenItemIsNotSpicyTextIsItemNameOnly() {
    // Arrange
    let item: MenuItem = .fixture(name: "name", spicy: false)
    let viewModel = MenuRow.ViewModel(item: item)

    // Assert
    XCTAssertEqual(viewModel.text, "name")
  }

  // 매운 메뉴는 이름 뒤에 🌶️ 이 붙는지 테스트
  func testWhenItemIsSpicyTextIsItemNameWithChiliEmoji() {
    // Arrange
    let item: MenuItem = .fixture(name: "name", spicy: true)
    let viewModel = MenuRow.ViewModel(item: item)

    // Assert
    XCTAssertEqual(viewModel.text, "name 🌶️")
  }

  func testCallsGivenGroupingFunction() throws {
    // 테스트 코드를 사용하지 않는 경우, Skip 을 활용할 수 있다.
    try XCTSkipIf(true, "skipping this for now, keeping it to reuse part of the code later on")
    var called = false
    let inputSections: [MenuSection] = [.fixture()]
    let spyClosure: ([MenuItem]) -> [MenuSection] = { items in
      called = true
      return inputSections
    }
    let menuItems: [MenuItem] = inputSections.flatMap { $0.items }
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingStub(returning: .success(menuItems)),
      menuGrouping: spyClosure)

    let sections = try viewModel.sections.get()
    XCTAssertTrue(called)
    // 반환된 값이 클로저로 생성된 값인지 확인합니다.
    XCTAssertEqual(sections, inputSections)
  }
}
