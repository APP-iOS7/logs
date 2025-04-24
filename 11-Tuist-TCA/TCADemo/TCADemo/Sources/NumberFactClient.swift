//
//  NumberFactClient.swift
//  TCADemo
//
//  Created by Jungman Bae on 4/24/25.
//

import Foundation
import Dependencies

// 예시: NumberFact 클라이언트 정의 (TCA 의존성 시스템)
struct NumberFactClient {
  var fetch: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
  static let liveValue = Self { number in
    let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
    return String(decoding: data, as: UTF8.self)
  }
  // 테스트용 값도 정의 가능
  static let testValue = Self { _ in "Test fact" }

  // Preview 용
  static let previewValue = Self { number in
    let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
    return String(decoding: data, as: UTF8.self)
  }
}

// DependencyKey 프로토콜을 준수하는 NumberFactClient 구조체
extension DependencyValues {
  var numberFact: NumberFactClient {
    get { self[NumberFactClient.self] }
    set { self[NumberFactClient.self] = newValue }
  }
}
