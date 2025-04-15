//
//  MenuGroupingTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/15/25.
//

import XCTest

@testable import Albertos

final class MenuGroupingTests: XCTestCase {

  // 한 카테고리당 섹션이 하나씩 있어야 한다.
  func testMenuWithManyCategoriesReturnsOneSectionPerCategory() {
    let menu: [MenuItem] = [
      .fixture(category: "drinks", name: "a drink"),
      .fixture(category: "pastas", name: "a pasta"),
      .fixture(category: "pastas", name: "another pasta"),
      .fixture(category: "desserts", name: "a dessert"),
    ].shuffled()

    let sections = groupMenuByCategory(menu)
    XCTAssertEqual(sections.count, 3)

    XCTAssertEqual(try XCTUnwrap(sections[safe: 0]?.category), "pastas")
    XCTAssertEqual(try XCTUnwrap(sections[safe: 1]?.category), "drinks")
    XCTAssertEqual(try XCTUnwrap(sections[safe: 2]?.category), "desserts")
  }

  // 카테고리가 하나인 경우 섹션도 하나여야 한다.
  func testMenuWithOneCategoryReturnsOneSection() {
    // Arrange
    let menu: [MenuItem] = [
      .fixture(category: "pastas", name: "name"),
      .fixture(category: "pastas", name: "other name"),
    ]

    // Act
    let sections = groupMenuByCategory(menu)

    // Assert
    // XCTAssertTrue(sections.count == 2) 는 불리언에 대한 결과만 제공
    // Equal Assert 가 조금 더 명확한 테스트 결과를 제공함
    XCTAssertEqual(sections.count, 1)

    do {
      // Arrange & Act
      let section = try XCTUnwrap(sections.first)

      // Assert
      XCTAssertEqual(section.items.count, 2)
      XCTAssertEqual(section.items.first?.name, "name")
      XCTAssertEqual(section.items.last?.name, "other name")
    } catch {
      XCTFail("Failed to unwrap section: \(error)")
    }
  }

  // 메뉴가 비어있으면 섹션도 비어있어야 한다.
  func testEmptyMenuReturnsEmptySections() {
    // Arrange: 빈 메뉴
    let menu = [MenuItem]()

    // Act
    let sections = groupMenuByCategory(menu)

    // Assert
    XCTAssertTrue(sections.isEmpty)
  }
}
