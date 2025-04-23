//
//  SearchViewController.swift
//  RxSwiftDemo
//
//  Created by Jungman Bae on 4/23/25.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

  // UI 요소들
  let searchBar = UISearchBar()
  let tableView = UITableView()
  let button = UIButton(type: .system)

  private let disposeBag = DisposeBag()
  private let viewModel: ViewModel = ViewModel(apiClient: APIClient()) // ViewModel 인스턴스

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
  }

  func setupUI() {
    title = "Search View Controller"
    view.backgroundColor = .white

    // Search Bar 설정
    searchBar.placeholder = "Search..."
    navigationItem.titleView = searchBar

    // TableView 설정
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    view.addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    // 버튼 설정
    button.setTitle("Search", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(button)

    NSLayoutConstraint.activate([
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.widthAnchor.constraint(equalToConstant: 100),
      button.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func bindViewModel() {
    // Search Bar의 텍스트 변경을 ViewModel의 searchText에 바인딩
    searchBar.rx.text.orEmpty
      .bind(to: viewModel.searchText)
      .disposed(by: disposeBag)

    // ViewModel의 searchResults를 TableView에 바인딩
    viewModel.searchResults
      .drive(tableView.rx.items(cellIdentifier: "cell")) { index, result, cell in
        cell.textLabel?.text = result // 검색 결과를 셀에 표시
      }
      .disposed(by: disposeBag)

    button.rx.tap.asSignal(onErrorSignalWith: .empty())
      .emit(onNext: { [weak self] in
        guard let self = self else { return }
        // 버튼 클릭 시 검색어로 API 호출
        print("Search button tapped")
        if let query = self.searchBar.text, !query.isEmpty {
          self.viewModel.searchText.onNext(query)
        }
      })
      .disposed(by: disposeBag)

  }
}

extension SearchViewController {
  class ViewModel {
    // 입력 (Signal 또는 Observable)
    var searchText = PublishSubject<String>() // 검색어 입력 스트림

    // 출력 (Driver) - UI 바인딩용
    var searchResults: Driver<[String]> // 검색 결과 스트림

    init(apiClient: APIClient) { // 가상의 API 클라이언트
      searchResults = searchText
        .debounce(.milliseconds(300), scheduler: MainScheduler.instance) // 입력 멈춘 후 0.3초 뒤
        .distinctUntilChanged() // 이전 검색어와 같으면 무시
        .flatMapLatest { query -> Observable<[String]> in // 최신 검색어로 API 호출
          if query.isEmpty {
            return Observable.just([]) // 빈 검색어면 빈 결과
          }
          return apiClient.search(query: query) // API 호출 (Observable 반환 가정)
            .catchAndReturn([]) // 에러 발생 시 빈 배열 반환
        }
        .asDriver(onErrorJustReturn: []) // Driver로 변환 (에러 시 빈 배열)
    }

  }
}

// 가상의 API 클라이언트
struct APIClient {
  func search(query: String) -> Observable<[String]> {
    // 실제 API 호출 로직 (예: URLSession)
    return Observable.create { observer in
      // Simulate network delay
      DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        let results = ["Result 1", "Result 2", "Result 3"] // Mock data
        observer.onNext(results)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}

#Preview {
  UINavigationController(rootViewController: SearchViewController())
}
