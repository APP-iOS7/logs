//
//  ItemTableViewController.swift
//  CoreDataDemo
//
//  Created by Jungman Bae on 3/20/25.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
  
  // MARK: - Properties
  private var items: [GridItem] = []
  
  private var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  
  private var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureTableView()
    configureSearchController()

    // 샘플 데이터 추가 버튼
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addNewItem)
    )
    
    // 데이터 로드
    loadGridItems()
  }
  
  func configureNavigation() {
    title = "Core Data 테이블"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func configureTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    tableView.rowHeight = 60
  }
  
  @objc func addNewItem() {
    // 랜덤 아이콘 목록
    let iconNames = ["star.fill", "heart.fill", "bell.fill", "cloud.fill",
                     "bolt.fill", "flame.fill", "leaf.fill", "sun.max.fill"]
    
    // 랜덤 타이틀 목록
    let titles = ["행복한", "멋진", "환상적인", "훌륭한", "놀라운", "대단한", "아름다운", "즐거운"]
    
    // 랜덤 아이템 생성
    let randomTitle = titles.randomElement() ?? "항목"
    let randomIcon = iconNames.randomElement() ?? "star.fill"
    let newItem = GridItem(title: randomTitle, imageSystemName: randomIcon)
    
    // Core Data에 저장
    saveGridItem(newItem)
  }
  
  // 데이터 저장
  private func saveGridItem(_ item: GridItem) {
    let _ = item.toManagedObject(in: viewContext)
    
    do {
      try viewContext.save()
      // 저장 후 UI 업데이트
      loadGridItems()
    } catch {
      print("저장 실패: \(error)")
    }
  }
  
  private func loadGridItems() {
    let request: NSFetchRequest<GridItemEntity> = GridItemEntity.fetchRequest()
    // 생성일 순으로 정렬
    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

    do {
      let result = try viewContext.fetch(request)
      items = result.compactMap { GridItem.from($0) }
      // 테이블 뷰 리로드
      tableView.reloadData()
    } catch {
      print("데이터 로드 실패: \(error)")
    }
  }

  // 데이터 삭제
  private func deleteGridItem(_ item: GridItem) {
    let request: NSFetchRequest<GridItemEntity> = GridItemEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id = %@", item.id as CVarArg)
    
    do {
      let result = try viewContext.fetch(request)
      guard let object = result.first else { return }
      
      viewContext.delete(object)
      try viewContext.save()
      
      // 삭제 후 UI 업데이트
      loadGridItems()
    } catch {
      print("삭제 실패: \(error)")
    }
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return items.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
    let item = items[indexPath.row]
    
    var content = cell.defaultContentConfiguration()
    content.text = item.title
    content.image = UIImage(systemName: item.imageSystemName)
    content.imageProperties.maximumSize = CGSize(width: 30, height: 30)
    content.imageProperties.tintColor = .systemBlue
    
    cell.contentConfiguration = content
    
    return cell
  }

  // MARK: - 테이블뷰 델리게이트 메서드
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let item = items[indexPath.row]

    // 확인 알림 표시
    let alert = UIAlertController(
      title: "아이템 삭제",
      message: "\(item.title)을(를) 삭제하시겠습니까?",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "취소", style: .cancel))
    alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
      self?.deleteGridItem(item)
    })

    present(alert, animated: true)
  }

  // 스와이프 삭제 기능 구현
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let item = items[indexPath.row]
      deleteGridItem(item)
    }
  }
}

// 검색 기능 구현
extension ItemTableViewController: UISearchResultsUpdating {

  // 검색 컨트롤러 설정
  func configureSearchController() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "검색"
    navigationItem.searchController = searchController

    // 네비게이션 바에 검색바가 숨겨지지 않도록 설정
    navigationItem.hidesSearchBarWhenScrolling = false

    // 검색 결과 화면을 현재 뷰 컨트롤러로 설정
    definesPresentationContext = true
  }

  // 검색 기능 구현
  func searchGridItems(_ text: String) {

    // 검색어가 없을 때 전체 데이터 로드
    if text.isEmpty {
      loadGridItems()
      return
    }

    let request: NSFetchRequest<GridItemEntity> = GridItemEntity.fetchRequest()

    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
    
    do {
      let result = try viewContext.fetch(request)
      items = result.compactMap { GridItem.from($0) }
      tableView.reloadData()
    } catch {
      print("검색 실패: \(error)")
    }
  }

  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    searchGridItems(text)
  }


}
