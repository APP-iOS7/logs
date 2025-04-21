import Foundation
import Alamofire
import Core

// API 통신 오류 정의
public enum NetworkError: Error {
  case invalidURL
  case requestFailed(Error)
  case decodingFailed(Error)
  case serverError(statusCode:Int)
  case unknown
}

// API 통신 서비스 (public으로 선언)
public class APIService {
  public static let shared = APIService() // 싱글톤 인스턴스
  private let baseURL = "https://fakestoreapi.com"

  private lazy var session: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30 // 요청 타임아웃 설정
    return Session(configuration: configuration)
  }()

  init() {}

  // 상품 목록 가져오기 (async/await 사용)
  @MainActor
  public func fetchProducts() async throws -> [Product] {
    let urlString = "\(baseURL)/products"

    guard let url = URL(string: urlString) else {
      throw NetworkError.invalidURL
    }

    do {
      // AF.request + await DataTask의 value 프로퍼티로 간단히 비동기 처리
      let products = try await session.request(url)
        .validate(statusCode: 200..<300)
        .serializingDecodable([Product].self) // 최신 Alamofire 비동기 API
        .value // 성공 시 [Product] 반환, 실패 시 Error throw
      return products
    } catch {
      // Alamofire 오류 또는 디코딩 오류 등을 NetworkError로 변환하거나 그대로 전달
      if let afError = error as? AFError {
        if afError.isResponseValidationError {
          throw NetworkError.decodingFailed(error)
        } else {
          throw NetworkError.requestFailed(error)
        }
      } else {
        throw NetworkError.unknown // 혹은 error 그대로 throw
      }
    }
  }
}
