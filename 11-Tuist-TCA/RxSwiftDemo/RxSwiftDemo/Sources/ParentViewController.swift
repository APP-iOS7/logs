//
//  ParentViewController.swift
//  RxSwiftDemo
//
//  Created by Jungman Bae on 4/22/25.
//

import UIKit

class ParentViewController: UIViewController {

  private let goToChildButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Go to Child View", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Parent View Controller"
    view.backgroundColor = .white
    setupUI()
  }

  func setupUI() {
    view.addSubview(goToChildButton)

    goToChildButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      goToChildButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      goToChildButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      goToChildButton.widthAnchor.constraint(equalToConstant: 200),
      goToChildButton.heightAnchor.constraint(equalToConstant: 50)
    ])

    goToChildButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      let childVC = ViewController()
      self.navigationController?.pushViewController(childVC, animated: true)
    }, for: .touchUpInside)
  }

}
