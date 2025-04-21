import SwiftUI
import Network // Product 모델 사용 위함

public struct ProductListView: View {
    // ViewModel 인스턴스 (StateObject로 View의 생명주기와 연결)
    @StateObject private var viewModel: ProductListViewModel

    // 외부에서 ViewModel을 주입받을 수 있도록 public init 추가
    public init(viewModel: ProductListViewModel = ProductListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView { // 네비게이션 바 사용
            Group { // 여러 뷰를 그룹화
                if viewModel.isLoading {
                    ProgressView("상품 목록 로딩중...") // 로딩 인디케이터
                } else if let errorMessage = viewModel.errorMessage {
                    Text("오류 발생: \(errorMessage)") // 오류 메시지 표시
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // 상품 목록 표시 List
                    List(viewModel.products) { product in
                        ProductRow(product: product) // 각 상품 행
                    }
                }
            }
            .navigationTitle("상품 목록") // 네비게이션 타이틀
            .task { // View가 나타날 때 비동기 작업 수행
                if viewModel.products.isEmpty { // 데이터가 없을 때만 로드
                    await viewModel.loadProducts()
                }
            }
            .refreshable { // 아래로 당겨서 새로고침 기능
                 await viewModel.loadProducts()
            }
        }
    }
}

// 상품 목록의 각 행을 위한 View
struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack {
            // AsyncImage: URL로부터 비동기 이미지 로딩 (iOS 15 이상)
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView() // 로딩 중
                case .success(let image):
                    image.resizable() // 이미지 로드 성공
                         .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo") // 로드 실패 시 기본 이미지
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50) // 이미지 크기 고정
            .clipShape(RoundedRectangle(cornerRadius: 8)) // 모서리 둥글게

            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2) // 최대 2줄
                Text("$\(product.price, specifier: "%.2f")") // 소수점 2자리까지
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer() // 오른쪽으로 밀기
        }
    }
}

// SwiftUI 미리보기 설정
struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        // 미리보기용 ViewModel 설정 (가짜 데이터 사용)
        let mockViewModel = ProductListViewModel()
        mockViewModel.products = [
//            Product(id: 1, title: "미리보기 상품 1", price: 19.99, image: ""),
//            Product(id: 2, title: "미리보기 상품 2 (아주 긴 이름 테스트)", price: 120.50, image: "")
        ]
//        mockViewModel.isLoading = true // 로딩 상태 미리보기
//        mockViewModel.errorMessage = "미리보기 오류 메시지" // 오류 상태 미리보기

        return ProductListView(viewModel: mockViewModel)
    }
}
