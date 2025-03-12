//
//  SecondViewController.swift
//  HelloWorld
//
//  Created by Jungman Bae on 3/12/25.
//

import UIKit

class SecondViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    print("01 SecondViewController.viewDidLoad()")
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("02 SecondViewController.viewWillAppear()")
  }

  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    print("03 SecondViewController.viewIsAppearing()")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("04 SecondViewController.viewDidAppear()")
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("05 SecondViewController.viewWillDisappear()")
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    print("06 SecondViewController.viewDidDisappear()")
  }

  func setupUI() {
    print("07 SecondViewController.setupUI()")
    // SecondViewController의 배경색을 노란색으로 설정
    self.view.backgroundColor = .yellow

    let label = UILabel()
    label.text = "Second View"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 24)
    label.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
    self.view.addSubview(label)
  }

}
