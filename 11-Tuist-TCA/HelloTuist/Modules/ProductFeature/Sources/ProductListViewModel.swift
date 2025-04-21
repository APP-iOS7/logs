import Foundation
import Combine
import Network
import Core

public class ProductListViewModel: ObservableObject {
  // MARK: - Published Properties
  @Published public var products: [Product] = []
  @Published public var isLoading = false
  @Published public var errorMessage: String?
  
  // MARK: - Dependencies
  private let apiService: APIService
  
  // MARK: - Initialization
  public init(apiService: APIService = APIService.shared) {
    self.apiService = apiService
  }
  
  // MARK: - Public Methods
  @MainActor
  public func loadProducts() async {
    // 상태 변경 전 예외 처리
    guard !isLoading else { return }
    
    // UI 상태 업데이트 (메인 스레드에서 실행됨)
    isLoading = true
    errorMessage = nil
    
    do {
      // Task를 사용하여 비동기 작업을 명시적으로 분리
      let fetchedProducts = try await apiService.fetchProducts()
      
      // UI 업데이트는 반드시 메인 스레드에서
      self.products = fetchedProducts
    } catch {
      // 안전한 오류 메시지 처리
      if let networkError = error as? NetworkError {
        self.errorMessage = networkError.localizedDescription
      } else {
        self.errorMessage = "데이터를 가져오는 중 오류가 발생했습니다: \(error.localizedDescription)"
      }
      print("상품 로딩 오류: \(error)")
    }
    
    // 마지막으로 로딩 상태 업데이트
    self.isLoading = false
  }
}
