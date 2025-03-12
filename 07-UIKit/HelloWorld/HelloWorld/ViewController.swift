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
    // (frame layout) 붙여질 뷰의 위치와 크기를 설정
    label.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
    // self.view(메인 뷰)에 라벨을 서브 뷰로 추가
    self.view.addSubview(label)

    // 버튼 추가

    let button = UIButton()
    button.setTitle("Go Second", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 40)
    button.addTarget(self, action: #selector(goSecond), for: .touchUpInside)

    self.view.addSubview(button)

    myLabel.frame = CGRect(x: 20, y: 300, width: view.frame.width - 40, height: 40)
    self.view.addSubview(myLabel)
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

