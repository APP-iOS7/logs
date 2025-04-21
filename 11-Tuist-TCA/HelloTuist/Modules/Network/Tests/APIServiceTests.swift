import XCTest
@testable import Core // Core 모듈 임포트 (Product 모델 사용)
@testable import Network // 테스트 대상 모듈 임포트

extension Product: @retroactive Encodable {
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case price
    case description
    case category
    case image
    case rating
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(price, forKey: .price)
    try container.encode(description, forKey: .description)
    try container.encode(category, forKey: .category)
    try container.encode(image, forKey: .image)
    try container.encode(rating, forKey: .rating)
  }

  static func fixture(id: Int, title: String, price: Double, image: String) -> Product {
    Product(
      id: id,
      title: title,
      price: price,
      description: "",
      category: "",
      image: image,
      rating: Rating(rate: 0.0, count: 0)
    )
  }
}

extension Product.Rating: @retroactive Encodable {
  enum CodingKeys: String, CodingKey {
    case rate
    case count
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(rate, forKey: .rate)
    try container.encode(count, forKey: .count)
  }
}

// APIService 테스트
class APIServiceTests: XCTestCase {

  var sut: APIService! // System Under Test: 테스트할 객체

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = APIService.shared
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  // fetchProducts 성공 테스트 (async 함수 테스트)
  func testFetchProducts_WhenRequestSucceeds_ShouldReturnProducts() async throws {
    // Given (준비물 없음)

    // When: async 함수 호출
    let products = try await sut.fetchProducts()

    // Then: 결과 검증
    XCTAssertFalse(products.isEmpty, "Product list should not be empty.")
    // 간단히 비어있지 않은지만 확인 (실제 API는 변동 가능성 있음)

    // 추가 검증 (옵션)
    if let firstProduct = products.first {
      XCTAssertGreaterThan(firstProduct.id, 0, "Product ID should be greater than 0")
      XCTAssertFalse(firstProduct.title.isEmpty, "Product title should not be empty")
      XCTAssertGreaterThan(firstProduct.price, 0, "Product price should be greater than 0")
      XCTAssertFalse(firstProduct.image.isEmpty, "Product image URL should not be empty")
    }
  }

  // URL이 유효하지 않을 때 테스트
  func testFetchProducts_WithInvalidURL_ShouldThrowError() async {
    // Given: 테스트용 서브클래스 생성
    class TestAPIService: APIService {
      override func fetchProducts() async throws -> [Product] {
        throw NetworkError.invalidURL
      }
    }

    let testService = TestAPIService.shared

    // When & Then: 에러가 발생하는지 확인
    do {
      _ = try await testService.fetchProducts()
      XCTFail("Should throw an error")
    } catch {
      XCTAssertTrue(error is NetworkError, "Error should be NetworkError")
      if let networkError = error as? NetworkError {
        XCTAssertEqual(networkError.localizedDescription, NetworkError.invalidURL.localizedDescription)
      }
    }
  }

  // Mock 서버 응답 테스트 (선택 사항)
  func testFetchProducts_WithMockData_ShouldDecodeCorrectly() async {
    // Given: Mock 데이터와 URLSession
    class MockURLProtocol: URLProtocol {
      static var mockData: Data?
      static var mockResponse: HTTPURLResponse?
      static var mockError: Error?

      override class func canInit(with request: URLRequest) -> Bool {
        return true
      }

      override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
      }

      override func startLoading() {
        if let error = MockURLProtocol.mockError {
          self.client?.urlProtocol(self, didFailWithError: error)
          return
        }

        if let response = MockURLProtocol.mockResponse {
          self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = MockURLProtocol.mockData {
          self.client?.urlProtocol(self, didLoad: data)
        }

        self.client?.urlProtocolDidFinishLoading(self)
      }

      override func stopLoading() {}
    }

    // Mock 데이터 설정
    let mockProducts: [Product] = [
      .fixture(id: 1, title: "Test Product", price: 99.99, image: "https://example.com/image.jpg")
    ]
    let encoder = JSONEncoder()
    let mockData = try! encoder.encode(mockProducts)
    let mockResponse = HTTPURLResponse(url: URL(string: "https://fakestoreapi.com/products")!, statusCode: 200, httpVersion: nil, headerFields: nil)!

    MockURLProtocol.mockData = mockData
    MockURLProtocol.mockResponse = mockResponse

    // Mock URLSession 설정
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    let mockSession = URLSession(configuration: configuration)

    // 테스트용 APIService 서브클래스 생성
    class TestAPIService: APIService {
      let mockSession: URLSession

      init(session: URLSession) {
        self.mockSession = session
        super.init()
      }

      override func fetchProducts() async throws -> [Product] {
        let urlString = "https://fakestoreapi.com/products"

        guard let url = URL(string: urlString) else {
          throw NetworkError.invalidURL
        }

        let request = URLRequest(url: url)

        do {
          let (data, response) = try await mockSession.data(for: request)

          guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
          }

          guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
          }

          let decoder = JSONDecoder()
          let products = try decoder.decode([Product].self, from: data)
          return products
        } catch let networkError as NetworkError {
          throw networkError
        } catch {
          throw NetworkError.requestFailed(error)
        }
      }
    }

    let testService = TestAPIService(session: mockSession)

    // When
    let products = try! await testService.fetchProducts()

    // Then
    XCTAssertEqual(products.count, 1)
    XCTAssertEqual(products[0].id, 1)
    XCTAssertEqual(products[0].title, "Test Product")
    XCTAssertEqual(products[0].price, 99.99)
  }
}
