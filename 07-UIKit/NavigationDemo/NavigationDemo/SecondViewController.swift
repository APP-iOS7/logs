//
//  SecondViewController.swift
//  NavigationDemo
//
//  Created by Jungman Bae on 3/19/25.
//

import UIKit

class SecondViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "두 번째 뷰"
    view.backgroundColor = .systemYellow

    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBlue
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.tintColor = .white // 아이템 색상

    let leftButton = UIBarButtonItem(
      systemItem: .cancel,
      primaryAction: UIAction { [weak self] _ in
      self?.leftButtonTapped()
    })
    navigationItem.leftBarButtonItem = leftButton

    let rightButton = UIBarButtonItem(
      title: "완료",
      primaryAction: UIAction { [weak self] _ in
      self?.rightButtonTapped()
    })

    let editButton = UIBarButtonItem(
      systemItem: .edit,
      primaryAction: UIAction { [weak self] _ in
      self?.editButtonTapped()
    })

    let searchButton = UIBarButtonItem(
      systemItem: .search,
      primaryAction: UIAction { [weak self] _ in
      self?.searchButtonTapped()
    })

    navigationItem.rightBarButtonItems = [rightButton, editButton, searchButton]
  }

  func leftButtonTapped() {
    print("왼쪽 버튼 클릭")
    // 네비게이션 백 버튼을 누른 것과 동일한 효과
    self.navigationController?.popViewController(animated: true)
  }

  func rightButtonTapped() {
    print("오른쪽 버튼 클릭")
  }

  func editButtonTapped() {
    print("편집 버튼 클릭")
  }

  func searchButtonTapped() {
    print("검색 버튼 클릭")
  }
}

#Preview {
  UINavigationController(rootViewController: ViewController())
}
