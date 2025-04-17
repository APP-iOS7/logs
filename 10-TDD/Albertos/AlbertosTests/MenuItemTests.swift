//
//  MenuItemTests.swift
//  AlbertosTests
//
//  Created by Jungman Bae on 4/17/25.
//
@testable import Albertos
import XCTest

final class MenuItemTests: XCTestCase {
  // 모든 입력 프로퍼티를 가진 JSON 데이터를 디코딩
  func testWhenDecodedFromJSONDataHasAllTheInputProperties() throws {
    let json = MenuItem.jsonFixture(name: "a name",
                                    category: "a category",
                                    spicy: false,
                                    price: 0.0)
    let data = try XCTUnwrap(json.data(using: .utf8))
    let item = try JSONDecoder().decode(MenuItem.self, from: data)
    XCTAssertEqual(item.name, "a name")
    XCTAssertEqual(item.category, "a category")
    XCTAssertEqual(item.spicy, false)
    XCTAssertEqual(item.price, 0.0)
  }

  func testDecodesFromJSONData() throws {
    let data = try dataFromJSONFileNamed("menu_item")
    let item = try JSONDecoder().decode(MenuItem.self, from: data)
    XCTAssertEqual(item.name, "a name")
    XCTAssertEqual(item.category, "a category")
    XCTAssertEqual(item.spicy, false)
    XCTAssertEqual(item.price, 0.0)
  }

}
