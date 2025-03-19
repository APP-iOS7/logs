//
//  SecondViewController.swift
//  TabDemo
//
//  Created by Jungman Bae on 3/19/25.
//

import UIKit

class SecondViewController: UIViewController {

  let dataLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20)
    label.textAlignment = .center
    label.text = "데이터가 없습니다"
    return label
  }()
  private var observer: NSObjectProtocol? // 옵저버 참조 저장

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Second"

    setupLabel()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }

  func setupLabel() {
    view.addSubview(dataLabel)
    dataLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      dataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    // NotificationCenter를 사용하여 데이터 변경 감지
    // 옵저버가 등록되기 전에는 데이터 감지가 불가능
    observer = NotificationCenter.default.addObserver(
      forName: DataManager.dataChangedNotification,
      object: nil,
      queue: .main) { [weak self] _ in
        self?.updateLabel()
      }
  }

  func updateLabel() {
    if DataManager.shared.data.isEmpty {
      dataLabel.text = "아직 데이터가 없습니다"
    } else {
      dataLabel.text = DataManager.shared.data
    }
  }

  // 옵저버 해제
  deinit {
    if let observer = observer {
      NotificationCenter.default.removeObserver(observer)
    }
  }
}
