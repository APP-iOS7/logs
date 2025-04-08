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
  // 기존 비동기 메서드
  func checkUserNameAvailableOldSchool(userName: String,
                                       completion: @Sendable @escaping (Result<Bool, NetworkError>) -> Void) {
    guard let url = URL(string: "http://localhost:8080/isUserNameAvailable?userName=\(userName)") else {
      // 반환 타입 대신, completion 핸들러를 사용하여 결과를 반환
      // failure를 반환
      completion(.failure(.invalidRequestError("URL invalid")))
      return
    }

    // URLSession을 사용하여 네트워크 요청을 생성
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let error {
        // 에러가 발생했을 경우
        // completion 핸들러를 사용하여 결과를 반환
        completion(.failure(.transportError(error)))
        return
      }

      if let response = response as? HTTPURLResponse,
         !(200...299).contains(response.statusCode) {
        // 서버에서 에러가 발생했을 경우 (4xx, 5xx)
        // completion 핸들러를 사용하여 결과를 반환
        completion(.failure(.serverError(
          statusCode: response.statusCode
        )))
        return
      }

      guard let data else {
        // 서버에서 데이터가 없을 경우
        completion(.failure(.noData))
        return
      }

      do {
        let decoder = JSONDecoder()
        // JSONDecoder를 사용하여 JSON 데이터를 디코딩
        let userAvailableMessage = try decoder.decode(UserNameAvailableMessage.self,from: data)

        // 디코딩이 성공했을 경우, userAvailableMessage의 isAvailable 프로퍼티를 반환
        completion(.success(userAvailableMessage.isAvailable))
      }
      catch {
        // 디코딩 에러가 발생했을 경우
        completion(.failure(.decodingError(error)))
      }
    }

    // 요청 태스크를 시작
    task.resume()
  }

  // Publisher 를 활용한 비동기 메서드
  nonisolated func checkUserNameAvailablePublisher(userName: String) -> AnyPublisher<Bool, Error> {
    guard let url = URL(string: "http://localhost:8080/isUserNameAvailable?userName=\(userName)") else {
      return Fail(error: APIError.invalidRequestError("URL invalid")).eraseToAnyPublisher()
    }

    return URLSession.shared.dataTaskPublisher(for: url)
    // URLSession을 사용하여 네트워크 요청에 대한 오류를 처리
      .mapError { APIError.transportError($0) }
      .tryMap { data, response in
        // 응답을 처리
        guard let httpResponse = response as? HTTPURLResponse else {
          // 응답이 HTTPURLResponse가 아닐 경우
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
          }
          throw APIError.invalidResponse
        }
      }
      .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
      .map(\.isAvailable)
      .eraseToAnyPublisher()
  }
}
