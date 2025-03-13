//
//  ViewController.swift
//  UIViewDemo
//
//  Created by Jungman Bae on 3/13/25.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStackView()
  }

  func setupStackView() {
    let stackView = UIStackView()
    stackView.backgroundColor = .lightGray
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false

    // 레이블 생성
    let label1 = UILabel()
    label1.backgroundColor = .systemRed
    label1.text = "Label 1"

    let label2 = UILabel()
    label2.backgroundColor = .systemBlue
    label2.text = "Label 2"

    let label3 = UILabel()
    label3.backgroundColor = .systemGreen
    label3.text = "Label 3"

    // 레이블을 stackView에 추가
    stackView.addArrangedSubview(label1)
    stackView.addArrangedSubview(label2)
    stackView.addArrangedSubview(label3)

    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      // safeAreaLayoutGuide를 기준으로 top, leading, trailing, height 제약조건 설정
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      stackView.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
}

#Preview {
  ViewController()
}
