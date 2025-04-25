@testable import StoreApp

import Foundation
import Testing
import ComposableArchitecture

struct StoreAppTests {

  // 성공적인 데이터 로딩 테스트
  @Test
  func testFetchProductsSuccess() async {
    // Mock 데이터 정의
    let mockProducts = [Product(id: 1, title: "테스트 상품", price: 10.0, description: "", category: "", image: "")]

    // TestStore 생성 및 의존성 재정의
    let store = await TestStore(initialState: ProductListFeature.State()) {
      ProductListFeature()
    } withDependencies: {
      // apiClient.fetchProducts가 즉시 성공하고 mockProducts를 반환하도록 설정
      $0.apiClient.fetchProducts = { mockProducts }
    }

    // 1. onAppear 액션 전송
    await store.send(.onAppear) {
      // 예상되는 상태 변화: isLoading = true
      $0.isLoading = true
    }

    // 2. 이펙트로부터 productsResponse(.success) 액션 수신 예상
    //    await 키워드 사용 필요
    await store.receive(\.productsResponse.success) {
      // 예상되는 상태 변화: isLoading = false, products 업데이트
      $0.isLoading = false
      $0.products = IdentifiedArray(uniqueElements: mockProducts)
    }
    // 테스트 종료 시점에 실행 중인 이펙트가 없어야 함
  }

  // 데이터 로딩 실패 테스트
  @Test
  func testFetchProductsFailure() async {
    // 테스트용 에러 정의
    struct TestError: Error, Equatable {}

    let store = await TestStore(initialState: ProductListFeature.State()) {
      ProductListFeature()
    } withDependencies: {
      // apiClient.fetchProducts가 에러를 발생시키도록 설정
      $0.apiClient.fetchProducts = { throw TestError() }
    }

    await store.send(.onAppear) {
      $0.isLoading = true
      $0.error = nil // 에러 상태 초기화 확인
    }

    // 이펙트로부터 productsResponse(.failure) 액션 수신 예상
    await store.receive(\.productsResponse.failure) {
      $0.isLoading = false
      $0.error = "데이터 로딩 실패: \(TestError().localizedDescription)" // 실제 에러 메시지 확인
    }
  }

  // 내비게이션 테스트 (상세 화면으로 이동)
  func testNavigationToDetail() async {
    let productToNavigate = Product(id: 1, title: "상세 이동 상품", price: 10.0, description: "", category: "", image: "")
    let store = await TestStore(initialState: ProductListFeature.State()) {
      ProductListFeature()
    } withDependencies: {
      // apiClient.fetchProducts가 즉시 성공하고 [productToNavigate] 를 반환하도록 설정
      $0.apiClient.fetchProducts = { [productToNavigate] }
    }

    // NavigationLink(state:)를 통해 path 액션이 전송되는 것을 시뮬레이션
    // 여기서는 직접 path 상태를 변경하여 테스트 (실제로는 View 상호작용 결과)
    let detailState = ProductDetailFeature.State(product: productToNavigate)
    await store.send(.path(.push(id: 0, state:.detail(detailState)))) {
      // path 스택에 detail 상태가 추가되었는지 확인
      $0.path[id: 0] = .detail(detailState)
    }
  }

}
