//
//  NewTodoItemViewController.swift
//  TodoApp
//
//  Created by Jungman Bae on 3/21/25.
//

import UIKit
import CoreData

class NewTodoItemViewController: UIViewController {

  var fetchResultsController: NSFetchedResultsController<Category>!

  lazy var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

  lazy var viewContext = persistentContainer.viewContext

  let titleField = UITextField()
  let categoryField = UITextField()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "새 할 일 추가"
    view.backgroundColor = .systemBackground

    configureTodoItemForm()
    fetchCategories()

    // 저장 버튼
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .save,
      target: self,
      action: #selector(saveTodoItem)
    )
  }

  @objc func saveTodoItem() {
    guard let title = titleField.text, !title.isEmpty else {
      let alert = UIAlertController(title: "제목을 입력하세요", message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default))
      present(alert, animated: true)
      return
    }

    let todoItem = TodoItem(context: viewContext)
    todoItem.title = title
    todoItem.createdAt = Date()

    if let category = fetchResultsController.fetchedObjects?.first(where: { $0.name == categoryField.text }) {
      todoItem.category = category
    } else {
      let newCategory = Category(context: viewContext)
      newCategory.name = categoryField.text
      newCategory.createdAt = Date()
      todoItem.category = newCategory
    }

    do {
      try viewContext.save()
      navigationController?.popViewController(animated: true)
    } catch {
      print("Failed to save todo item: \(error)")
    }
  }

  func configureTodoItemForm() {
    // TodoItem title 입력 필드

    titleField.font = .systemFont(ofSize: 20)
    titleField.placeholder = "할 일을 입력하세요."
    titleField.borderStyle = .roundedRect
    titleField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleField)

    // Category name 입력 드롭다운 (with 입력필드)
    categoryField.font = .systemFont(ofSize: 20)
    categoryField.placeholder = "카테고리를 선택하세요."
    categoryField.borderStyle = .roundedRect
    categoryField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(categoryField)

    let recommendationTableView = UITableView()

    recommendationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    recommendationTableView.dataSource = self
    recommendationTableView.delegate = self

    recommendationTableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(recommendationTableView)

    NSLayoutConstraint.activate([
      titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      categoryField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 40),
      categoryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      categoryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      recommendationTableView.topAnchor.constraint(equalTo: categoryField.bottomAnchor),
      recommendationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      recommendationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      recommendationTableView.heightAnchor.constraint(equalToConstant: 200)
    ])

  }

  func fetchCategories() {
    let request: NSFetchRequest<Category> = Category.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]

    fetchResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    do {
      try fetchResultsController.performFetch()
    } catch {
      print("Failed to fetch categories: \(error)")
    }
  }
}

extension NewTodoItemViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchResultsController.fetchedObjects?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = fetchResultsController.object(at: indexPath).name
    return cell
  }
}

extension NewTodoItemViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

#Preview {
  UINavigationController(rootViewController: NewTodoItemViewController())
}
