//
//  ViewController.swift
//  DiffableDataSourceDemo
//
//  Created by Jungman Bae on 3/24/25.
//

import UIKit

class ViewController: UIViewController {

  // Section을 정의하는 enum (Hashable 필요)
  enum Section: Hashable {
    case main
  }

  // Item을 정의하는 struct, Hashable을 채택하여 고유 식별 가능
  struct Item: Hashable {
    let id = UUID() // 고유한 ID
    let title: String

    // Hashable 구현은 자동으로 처리됨
    // Equatable 또한 자동 구현됨
  }

  var tableView: UITableView!
  var dataSource: UITableViewDiffableDataSource<Section, Item>!

  override func viewDidLoad() {
    super.viewDidLoad()

    // 네비게이션 설정
    configureNavigation()
    // 테이블 뷰 구성
    configureTableView()
    // 디퍼블데이터소스 구성
    configureDataSource()
    // 데이터 로드
    updateData()
  }

  func configureNavigation() {
    title = "Diffable Data Source"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
  }

  func configureTableView() {
    // 테이블 뷰 생성 및 설정
    tableView = UITableView(frame: view.bounds, style: .plain)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.delegate = self

    // 셀 등록 - UITableViewCell.self 대신 커스텀 셀 사용 가능
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    view.addSubview(tableView)

    // 테이블 뷰 스타일 설정
    tableView.backgroundColor = .systemGroupedBackground
    tableView.separatorStyle = .singleLine
  }

  func configureDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView,
                                                              cellProvider: { tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

      // iOS 14+ 셀 구성 방법 - 더 체계적인 설정 가능
      var content = cell.defaultContentConfiguration()
      content.text = item.title
      content.secondaryText = "ID: \(item.id.uuidString)"
      cell.contentConfiguration = content

      return cell
    })
  }

  func updateData() {
    // 샘플 데이터
    let items = (0..<10).map { Item(title: "Item \($0)") }
    // 스냅샷 생성
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    // 데이터 소스에 스냅샷 적용
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  @objc func addNewItem() {
    // 1. 현재 스냅샷 가져오기
    var snapshot = dataSource.snapshot()

    // 2. 새 아이템 생성
    let newItem = Item(title: "New \(Date().timeIntervalSince1970)")

    // 3. 스냅샷에 아이템 추가
    snapshot.insertItems([newItem], beforeItem: snapshot.itemIdentifiers.first!)

    // 4. 스냅샷 적용
    dataSource.apply(snapshot, animatingDifferences: true)
  }

  func deleteItem(_ item: Item) {
    // 1. 현재 스냅샷 가져오기
    var snapshot = dataSource.snapshot()

    // 2. 스냅샷에서 아이템 제거
    snapshot.deleteItems([item])

    // 3. 스냅샷 적용
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = dataSource.itemIdentifier(for: indexPath)!
    print("Selected item: \(item)")
    deleteItem(item)
  }
}

#Preview {
  UIStoryboard(name: "Main", bundle: nil)
    .instantiateInitialViewController()!
}
