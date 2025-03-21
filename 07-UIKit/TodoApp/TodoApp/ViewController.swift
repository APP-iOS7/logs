//
//  ViewController.swift
//  TodoApp
//
//  Created by Jungman Bae on 3/21/25.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "UIKit Todo"
    navigationController?.navigationBar.prefersLargeTitles = true

    configureTodoList()
    addNewTodoItemButton()
  }

  func configureTodoList() {
    let todoList = UITableView(frame: .zero, style: .insetGrouped)
    todoList.translatesAutoresizingMaskIntoConstraints = false
    todoList.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    todoList.dataSource = self
    todoList.delegate = self

    view.addSubview(todoList)

    NSLayoutConstraint.activate([
      todoList.topAnchor.constraint(equalTo: view.topAnchor),
      todoList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      todoList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      todoList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "Todo Item"
    return cell
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
