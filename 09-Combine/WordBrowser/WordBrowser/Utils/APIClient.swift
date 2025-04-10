//
//  APIClient.swift
//  WordBrowser
//
//  Created by Jungman Bae on 4/10/25.
//
import Foundation

// MARK: - 오류 열거형
enum WordsAPIError: Error, LocalizedError {
  case invalidURL
  case invalidServerResponse
  case decodingError(Error)
  case networkError(Error)
  case apiKeyMissing

  var errorDescription: String? {
    switch self {
    case .invalidURL: return "잘못된 URL이 생성되었습니다."
    case .invalidServerResponse: return "잘못된 서버 응답입니다."
    case .decodingError(let error): return "JSON 디코딩 오류: \(error.localizedDescription)"
    case .networkError(let error): return "네트워크 오류: \(error.localizedDescription)"
    case .apiKeyMissing: return "API 키가 누락되었습니다. 설정 섹션에 추가해주세요."
    }
  }
}

struct APIClient {
  private static let decoder = JSONDecoder()

  static func buildURLRequest(for searchTerm: String, random: Bool = false) throws -> URLRequest {
    guard let rapidApiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String,
          let rapidApiHost = Bundle.main.object(forInfoDictionaryKey: "APIHost") as? String,
          let wordsApiBaseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
      throw WordsAPIError.apiKeyMissing
    }

    debugPrint("API 키: \(rapidApiKey)") // 디버깅
    debugPrint("API 호스트: \(rapidApiHost)") // 디버깅
    debugPrint("API 기본 URL: \(wordsApiBaseURL)") // 디버깅

    // 요청된 경우 랜덤 엔드포인트를 사용하고, 그렇지 않으면 용어를 검색
    let urlString = random ? (wordsApiBaseURL + "?random=true") : (wordsApiBaseURL + searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)

    debugPrint("요청 URL 문자열: \(urlString)") // 디버깅

    guard let url = URL(string: urlString) else {
      throw WordsAPIError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(rapidApiKey, forHTTPHeaderField: "X-RapidAPI-Key")
    request.setValue(rapidApiHost, forHTTPHeaderField: "X-RapidAPI-Host")

    debugPrint("요청 URL: \(url.absoluteString)") // 디버깅

    return request
  }

  static func fetchWord(_ request: URLRequest) async throws -> Word {
    do {
      let (data, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw WordsAPIError.invalidServerResponse
      }

      debugPrint("받은 상태 코드: \(httpResponse.statusCode)") // 디버깅

      guard httpResponse.statusCode == 200 else {
        // 가능한 경우 여기에서 API의 오류 메시지를 디코딩할 수 있습니다.
        debugPrint("오류 응답 데이터: \(String(data: data, encoding: .utf8) ?? "데이터 없음")")
        throw WordsAPIError.invalidServerResponse
      }

      do {
        let word = try decoder.decode(Word.self, from: data)
        return word
      } catch {
        debugPrint("디코딩 실패: \(error)") // 디버깅
        throw WordsAPIError.decodingError(error)
      }
    } catch let error as WordsAPIError {
      throw error // 사용자 정의 오류 다시 던지기
    } catch {
      throw WordsAPIError.networkError(error) // 다른 오류 래핑
    }
  }

  // 검색을 위한 특정 함수
  static func search(for searchTerm: String) async throws -> Word {
    guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      // 빈 문자열 검색 방지
      return Word.empty
    }
    let request = try buildURLRequest(for: searchTerm)
    return try await fetchWord(request)
  }

  // 임의의 단어를 가져오는 특정 함수
  static func fetchRandomWord() async throws -> Word {
    let request = try buildURLRequest(for: "", random: true) // 빈 검색어, 랜덤 플래그 설정
    return try await fetchWord(request)
  }
}
