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
}
