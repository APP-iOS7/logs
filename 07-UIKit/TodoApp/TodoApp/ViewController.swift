//
//  ViewController.swift
//  TodoApp
//
//  Created by Jungman Bae on 3/21/25.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  var filterDone = false

  // UIFetchedResultsController를 사용하여 데이터를 가져오기 위한 프로퍼티
  var fetchedResultsController: NSFetchedResultsController<TodoItem>!

  lazy var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

  lazy var viewContext = persistentContainer.viewContext

  let tableView = UITableView(frame: .zero, style: .insetGrouped)

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "UIKit Todo"
    navigationController?.navigationBar.prefersLargeTitles = true

    configureTodoList()
    setupBarButton()
    addNewTodoItemButton()
    fetchTodoItems()
    configureSearchController()
  }

  func configureTodoList() {
    tableView.translatesAutoresizingMaskIntoConstraints = false

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.dataSource = self
    tableView.delegate = self

    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  func setupBarButton() {
    // 필터 토글 상태에 따른 버튼 아이콘 변경
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: !filterDone ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill"),
      style: .plain,
      target: self,
      action: #selector(toggleDoneFilter)
    )
  }

  @objc func toggleDoneFilter(_ sender: UIBarButtonItem) {
    filterDone.toggle()
    setupBarButton()

    fetchTodoItems()
  }

  func addNewTodoItemButton() {
    let button = UIButton()

    var config = UIButton.Configuration.filled()
    config.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
    config.imagePadding = 10

    button.configuration = config
    button.layer.cornerRadius = 30
    button.clipsToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false

    button.addAction(UIAction { [weak self] _ in
      let newTodoItemVC = NewTodoItemViewController()
      self?.navigationController?.pushViewController(newTodoItemVC, animated: true)
    }, for: .touchUpInside)

    view.addSubview(button)

    NSLayoutConstraint.activate([
      button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      button.widthAnchor.constraint(equalToConstant: 60),
      button.heightAnchor.constraint(equalToConstant: 60)
    ])
  }

  func fetchTodoItems() {
    let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
    // prefetching을 위해 relationshipKeyPathsForPrefetching 프로퍼티에 category 속성을 추가합니다.
    request.relationshipKeyPathsForPrefetching = ["category"]

    let sortDescriptor1 = NSSortDescriptor(key: "category.name", ascending: true)
    let sortDescriptor2 = NSSortDescriptor(key: "createdAt", ascending: false)
    request.sortDescriptors = [sortDescriptor1,sortDescriptor2]

    request.predicate = filterDone ? NSPredicate(format: "isDone == false") : nil

    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: "category", cacheName: nil)

    fetchedResultsController?.delegate = self

    do {
      try fetchedResultsController.performFetch()
      tableView.reloadData()
    } catch {
      print("Failed to fetch items: \(error)")
    }
  }
}

extension ViewController: NSFetchedResultsControllerDelegate {

  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("Content will change")
    // 테이블 뷰 변경 애니메이션 시작
    tableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    print("Object changed")
    // 테이블 뷰 변경 애니메이션 적용: 데이터 추가, 삭제, 업데이트, 이동
    switch type {
    case .insert:
      if let newIndexPath = newIndexPath {
        if tableView.numberOfSections < (controller.sections?.count ?? 0) {
          tableView.insertSections(IndexSet(integer: newIndexPath.section), with: .automatic)
        }
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    case .delete:
      if let indexPath = indexPath {
        if tableView.numberOfRows(inSection: indexPath.section) == 1 {
          tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
          tableView.deleteRows(at: [indexPath], with: .automatic)
        }
      }
    case .update:
      if let indexPath = indexPath {
        tableView.reloadRows(at: [indexPath], with: .automatic)
      }
    case .move:
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        tableView.moveRow(at: indexPath, to: newIndexPath)
      }
    @unknown default:
      break
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("Content changed")
    // 테이블 뷰 변경 애니메이션 종료
    tableView.endUpdates()
  }
}

extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    var config = cell.defaultContentConfiguration()
    config.text = fetchedResultsController.object(at: indexPath).title
    config.secondaryText = fetchedResultsController.object(at: indexPath).category?.name
    // isDone 상태 표시
    config.image = UIImage(systemName: fetchedResultsController.object(at: indexPath).isDone ? "checkmark.square" : "square")

    cell.contentConfiguration = config
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let todoItem = fetchedResultsController.object(at: IndexPath(row: 0, section: section))
    return todoItem.category?.name
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let item = fetchedResultsController.object(at: indexPath)

    viewContext.performAndWait {
      do {
        item.isDone.toggle()
        try viewContext.save()
      } catch {
        print("Failed to save item: \(error)")
      }
    }
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
      guard let self = self else { return }
      let item = self.fetchedResultsController.object(at: indexPath)
      self.viewContext.delete(item)
      do {
        try self.viewContext.save()
        completion(true)
      } catch {
        print("Failed to delete item: \(error)")
        completion(false)
      }
    }

    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}

// 검색 기능 구현
extension ViewController: UISearchResultsUpdating {

  // 검색 컨트롤러 설정
  func configureSearchController() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "검색"

    navigationItem.searchController = searchController

    // 검색 결과 화면을 현재 뷰 컨트롤러로 설정
    definesPresentationContext = true
  }

  // 검색 기능 구현
  func searchTodoItems(_ text: String) {

    // 검색어가 없을 때 전체 데이터 로드
    if text.isEmpty {
      fetchTodoItems()
      return
    }

    let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()

    request.relationshipKeyPathsForPrefetching = ["category"]

    let sortDescriptor1 = NSSortDescriptor(key: "category.name", ascending: true)
    let sortDescriptor2 = NSSortDescriptor(key: "createdAt", ascending: false)
    request.sortDescriptors = [sortDescriptor1,sortDescriptor2]

    request.predicate = filterDone ? NSPredicate(format: "isDone == false") : nil

    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)

    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: "category", cacheName: nil)
    fetchedResultsController?.delegate = self

    do {
      try fetchedResultsController.performFetch()
      tableView.reloadData()
      print("검색 결과: \(fetchedResultsController.fetchedObjects?.count ?? 0) 건")
    } catch {
      print("검색 실패: \(error)")
    }
  }

  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    print("Search text: \(text)")
    searchTodoItems(text)
  }
}
