//
//  ViewController.swift
//  HelloWorld
//
//  Created by Jungman Bae on 3/12/25.
//

import UIKit

class ViewController: UIViewController, SecondViewControllerDelegate {

  // lazy var: 초기화를 늦게 하기 위해 사용하는 키워드
  lazy var myLabel: UILabel = {
    print("myLabel 생성")
    let label = UILabel()
    label.text = "입력 결과를 출력합니다."
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 24)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    print("01 ViewController.viewDidLoad()")
    setupUI()
  }

  func setupUI() {
    let label = UILabel()
    label.text = "Hello, World!"
    // (content layout) 라벨의 텍스트를 가운데 정렬
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 24)
    // autolayout 설정
    label.translatesAutoresizingMaskIntoConstraints = false
    // self.view(메인 뷰)에 라벨을 서브 뷰로 추가
    self.view.addSubview(label)

    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
      label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      label.heightAnchor.constraint(equalToConstant: 40)
    ])

    // 버튼 추가

    let button = UIButton()
    button.setTitle("Go Second", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.addTarget(self, action: #selector(goSecond), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(button)

    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: label.topAnchor, constant: 100),
      button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      button.heightAnchor.constraint(equalToConstant: 40)
    ])

    self.view.addSubview(myLabel)

    NSLayoutConstraint.activate([
      myLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 100),
      myLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      myLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      myLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
  }

  func didDismissSecondViewController(message: String) {
      myLabel.text = message
  }

  @objc func goSecond() {
    let secondVC = SecondViewController()
    secondVC.delegate = self
    self.present(secondVC, animated: true)
  }
}

