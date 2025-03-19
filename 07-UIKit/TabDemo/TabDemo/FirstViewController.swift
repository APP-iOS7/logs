//
//  FirstViewController.swift
//  TabDemo
//
//  Created by Jungman Bae on 3/19/25.
//

import UIKit

class FirstViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "First"

    setupButton()
  }

  func setupButton() {
    let button = UIButton(type: .system)
    button.setTitle("데이터 전달", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 20)
    button.sizeToFit()
    button.center = view.center
    button.addAction(UIAction { [weak self] _ in
      self?.didTapButton()
    }, for: .touchUpInside)
    view.addSubview(button)
  }

  func didTapButton() {
    let data = "전달할 데이터입니다."
    DataManager.shared.updateData(data)
  }
}
