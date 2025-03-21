//
//  NewTodoItemViewController.swift
//  TodoApp
//
//  Created by Jungman Bae on 3/21/25.
//

import UIKit

class NewTodoItemViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "새 할 일 추가"
    view.backgroundColor = .systemBackground

    configureTodoItemForm()
  }

  func configureTodoItemForm() {
    // TodoItem title 입력 필드
    let titleField = UITextField()

    titleField.font = .systemFont(ofSize: 20)
    titleField.placeholder = "할 일을 입력하세요."
    titleField.borderStyle = .roundedRect
    titleField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleField)

    // Category name 입력 드롭다운 (with 입력필드)
    let categoryField = UITextField()
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
}

extension NewTodoItemViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "Category \(indexPath.row)"
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
