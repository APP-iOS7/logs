//
//  ViewController.swift
//  FormDemo
//
//  Created by Jungman Bae on 3/17/25.
//

import UIKit

class GroupBoxViewController: UIViewController {

  var flag = false
  let groupBox = UIView()
  let groupBoxLabel = UILabel()
  let toggle = UISwitch()
  let textField = UITextField()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    setupGroupBox()
  }

  func setupGroupBox() {
    groupBox.layer.borderWidth = 1
    groupBox.layer.borderColor = UIColor.lightGray.cgColor
    groupBox.layer.cornerRadius = 8
    groupBox.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(groupBox)

    NSLayoutConstraint.activate([
      groupBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      groupBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      groupBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      groupBox.heightAnchor.constraint(equalToConstant: 200)
    ])
  }


}

