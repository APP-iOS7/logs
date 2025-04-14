//
//  TestableDemoTests.swift
//  TestableDemoTests
//
//  Created by Jungman Bae on 4/14/25.
//

import XCTest
@testable import TestableDemo

final class TestableDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
      let result = fizzBuzz(3)
      XCTAssertEqual(result, "Fizz")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
