//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by Jungman Bae on 3/24/25.
//

import UIKit

class ViewController: UIViewController {
  // 데이터 소스 타입 정의
  enum Section {
    case main
  }

  // 그리드에 표시할 아이템 데이터
  private let items = [
    GridItem(title: "홈", imageSystemName: "house.fill"),
    GridItem(title: "검색", imageSystemName: "magnifyingglass"),
    GridItem(title: "좋아요", imageSystemName: "heart.fill"),
    GridItem(title: "설정", imageSystemName: "gear"),
    GridItem(title: "사진", imageSystemName: "photo"),
    GridItem(title: "메시지", imageSystemName: "message.fill"),
    GridItem(title: "알림", imageSystemName: "bell.fill"),
    GridItem(title: "음악", imageSystemName: "music.note"),
    GridItem(title: "달력", imageSystemName: "calendar"),
    GridItem(title: "지도", imageSystemName: "map.fill"),
    GridItem(title: "북마크", imageSystemName: "bookmark.fill"),
    GridItem(title: "시계", imageSystemName: "clock.fill"),
  ]

  // 컬렉션 뷰 선언
  private var collectionView: UICollectionView!

  // 디퍼블 데이터 소스 선언
  private var dataSource: UICollectionViewDiffableDataSource<Section, GridItem>!

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    setupCollectionView()
    configureDataSource()
    applySnapshot()
  }

  func configureNavigation() {
    title = "Collection View"
    navigationController?.navigationBar.prefersLargeTitles = true
    let searchController = UISearchController(searchResultsController: nil)
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "검색"
    searchController.searchBar.delegate = self
  }

  func setupCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)

    view.addSubview(collectionView)

    collectionView.delegate = self
  }

  func createLayout() -> UICollectionViewLayout {
    // 아이템 정의
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

    // 그룹 정의 (가로 방향으로 3개의 아이템)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalWidth(1/3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])

    // 섹션 정의
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

    // 최종 레이아웃 반환
    return UICollectionViewCompositionalLayout(section: section)
  }

  func configureDataSource () {
    dataSource = UICollectionViewDiffableDataSource<Section, GridItem>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: GridCollectionViewCell.identifier,
          for: indexPath
        ) as! GridCollectionViewCell

        cell.configure(with: item)
        return cell
      }
    )
  }

  // 스냅샷 적용
  private func applySnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, GridItem>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
    print("Selected item: \(item)")

    let alert = UIAlertController(
      title: "선택된 아이템",
      message: item.title,
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    present(alert, animated: true)
  }

  private func filterItems(containing text: String) {
    let filteredItems = items.filter { $0.title.contains(text) }
    var snapshot = NSDiffableDataSourceSnapshot<Section, GridItem>()
    snapshot.appendSections([.main])
    snapshot.appendItems(filteredItems, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      applySnapshot()
    } else {
      filterItems(containing: searchText)
    }
  }
}
