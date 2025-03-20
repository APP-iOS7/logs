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

    do {
      let result = try viewContext.fetch(request)
      items = result.compactMap { GridItem.from($0) }
      // 테이블 뷰 리로드
      tableView.reloadData()
    } catch {
      print("데이터 로드 실패: \(error)")
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

}
