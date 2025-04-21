import SwiftUI
import Core

public struct ProductListView: View {
  // StateObject로 ViewModel 선언 (View의 생명주기와 함께 유지)
  @StateObject private var viewModel: ProductListViewModel

  // 외부에서 ViewModel 주입 가능
  public init(viewModel: ProductListViewModel = ProductListViewModel()) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    NavigationView {
      Group {
        if viewModel.isLoading {
          loadingView
        } else if let errorMessage = viewModel.errorMessage {
          errorView(message: errorMessage)
        } else if viewModel.products.isEmpty {
          emptyStateView
        } else {
          productListView
        }
      }
      .navigationTitle("상품 목록")
      .task {
        // 데이터가 없을 때만 로드 (중복 로드 방지)
        if viewModel.products.isEmpty && viewModel.errorMessage == nil && !viewModel.isLoading {
          await viewModel.loadProducts()
        }
      }
      .refreshable {
        // 새로고침 시 강제로 다시 로드
        await viewModel.loadProducts()
      }
    }
  }

  // MARK: - 하위 뷰 컴포넌트들

  private var loadingView: some View {
    VStack {
      ProgressView()
        .scaleEffect(1.5)
        .padding()
      Text("상품 목록 로딩중...")
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func errorView(message: String) -> some View {
    VStack(spacing: 16) {
      Image(systemName: "exclamationmark.triangle")
        .font(.largeTitle)
        .foregroundColor(.red)

      Text("오류 발생")
        .font(.headline)

      Text(message)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Button("다시 시도") {
        Task {
          await viewModel.loadProducts()
        }
      }
      .buttonStyle(.bordered)
      .padding(.top)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var emptyStateView: some View {
    VStack(spacing: 16) {
      Image(systemName: "cart")
        .font(.system(size: 60))
        .foregroundColor(.secondary)

      Text("상품이 없습니다")
        .font(.headline)

      Text("상품 목록을 불러올 수 없습니다.\n다시 시도해 주세요.")
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Button("새로고침") {
        Task {
          await viewModel.loadProducts()
        }
      }
      .buttonStyle(.bordered)
      .padding(.top)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var productListView: some View {
    List {
      ForEach(viewModel.products) { product in
        ProductRow(product: product)
      }
    }
    .listStyle(.plain)
  }
}

// 상품 목록의 각 행을 위한 View
struct ProductRow: View {
  let product: Product

  var body: some View {
    HStack(spacing: 12) {
      // 이미지 부분
      productImage

      // 텍스트 정보 부분
      productInfo

      Spacer()
    }
    .padding(.vertical, 8)
  }

  private var productImage: some View {
    AsyncImage(url: URL(string: product.image)) { phase in
      switch phase {
      case .empty:
        ProgressView()
          .frame(width: 60, height: 60)
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 60, height: 60)
      case .failure:
        Image(systemName: "photo")
          .font(.system(size: 30))
          .foregroundColor(.gray)
          .frame(width: 60, height: 60)
      @unknown default:
        EmptyView()
      }
    }
    .frame(width: 60, height: 60)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .background(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    )
  }

  private var productInfo: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(product.title)
        .font(.system(size: 16, weight: .medium))
        .lineLimit(2)
        .multilineTextAlignment(.leading)

      Text("$\(String(format: "%.2f", product.price))")
        .font(.system(size: 14, weight: .semibold))
        .foregroundColor(.blue)
    }
  }
}
