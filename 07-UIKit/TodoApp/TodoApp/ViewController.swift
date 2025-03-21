//
//  ViewController.swift
//  TodoApp
//
//  Created by Jungman Bae on 3/21/25.
//

import UIKit
import CoreData

class ViewController: UIViewController {

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
    addNewTodoItemButton()
    fetchTodoItems()
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
    let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
    request.sortDescriptors = [sortDescriptor]

    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: "category.name", cacheName: nil)
    fetchedResultsController?.delegate = self

    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Failed to fetch items: \(error)")
    }
  }
}

extension ViewController: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("Content changed")
    tableView.reloadData()
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
    cell.textLabel?.text = fetchedResultsController.object(at: indexPath).title
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return fetchedResultsController.sections?[section].name
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

#Preview {
  UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
}
