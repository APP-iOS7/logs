//
//  AuthenticationService.swift
//  CombineDemo
//
//  Created by Jungman Bae on 4/7/25.
//

import Foundation
import Combine

// 에러 타입 정의
enum APIError: LocalizedError {
  /// 잘못된 요청, 예: 잘못된 URL
  case invalidRequestError(String)
  case transportError(Error)
  case invalidResponse
  case validationError(String)
  case decodingError(Error)
  case serverError(statusCode: Int, reason: String, retryAfter: Int)

  var errorDescription: String? {
    switch self {
    case .invalidRequestError(let message):
      return "Invalid request: \(message)"
    case .transportError(let error):
      return "Transport error: \(error)"
    case .invalidResponse:
      return "Invalid response"
    case .validationError(let reason):
      return "Validation Error: \(reason)"
    case .decodingError:
      return "The server returned data in an unexpected format. Try updating the app."
    case .serverError(let statusCode, let reason, let retryAfter):
      return "Server error: \(statusCode) - \(reason). Retry after \(retryAfter) seconds."
    }
  }

}

struct APIErrorMessage: Decodable {
  var error: Bool
  var reason: String
}

enum NetworkError: Error {
  case invalidRequestError(String)
  case transportError(Error)
  case serverError(statusCode: Int)
  case decodingError(Error)
  case noData
}

struct UserNameAvailableMessage: Codable {
  let isAvailable: Bool
  let userName: String
}

actor AuthenticationService {
  // Publisher 를 활용한 비동기 메서드
  nonisolated func checkUserNameAvailablePublisher(userName: String) -> AnyPublisher<Bool, Error> {
    guard let url = URL(string: "http://localhost:8080/isUserNameAvailable?userName=\(userName)") else {
      return Fail(error: APIError.invalidRequestError("URL invalid")).eraseToAnyPublisher()
    }

    func makeRequest() -> AnyPublisher<Bool, Error> {
      return URLSession.shared.dataTaskPublisher(for: url)
        .mapError { APIError.transportError($0) }
        .tryMap { data, response in
          // 응답을 처리
          guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
          }

          if (200..<300).contains(httpResponse.statusCode) {
            // 성공적인 응답일 경우
            return data
          } else {
            // 실패한 응답일 경우
            let decoder = JSONDecoder()
            let apiError = try decoder.decode(APIErrorMessage.self, from: data)
            // 서버에서 에러가 발생했을 경우
            if httpResponse.statusCode == 400 {
              throw APIError.validationError(apiError.reason)
            } else if (500..<600) ~= httpResponse.statusCode {
              let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After") ?? "0"
              // 서버 에러
              throw APIError.serverError(
                statusCode: httpResponse.statusCode,
                reason: apiError.reason,
                retryAfter: Int(retryAfter) ?? 0
              )
            } else {
              // 기타 에러
              throw APIError.invalidResponse
            }
          }
        }
        .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
        .map(\.isAvailable)
        .eraseToAnyPublisher()
    }

    return makeRequest()
      .catch { error -> AnyPublisher<Bool, Error> in
        if case APIError.serverError(_, _, let retryAfter) = error {
          print("Retrying after \(retryAfter) seconds...")          
          let delayTime = retryAfter > 0 ? TimeInterval(retryAfter) : 0.1
          return Just(())
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .flatMap { _ in makeRequest() }
            .retry(10)
            .eraseToAnyPublisher()
        } else {
          return Fail(error: error).eraseToAnyPublisher()
        }
      }
    .eraseToAnyPublisher()
  }
}
