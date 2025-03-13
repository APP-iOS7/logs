//
//  CustomViewController.swift
//  DelegateDemo
//
//  Created by Jungman Bae on 3/13/25.
//

import UIKit

// MARK: - 델리게이트 프로토콜 정의
// 커스텀 뷰 컨트롤러가 다른 클래스에게 알릴 이벤트를 정의합니다
protocol CustomViewControllerDelegate: AnyObject {
  // 필수 메서드: 사용자가 버튼을 탭했을 때 호출됩니다
  func didTapButton(withText text: String)

  // 선택적 메서드: 뷰가 나타날 때 호출됩니다
  func willAppear()
}

// 프로토콜 확장을 사용하여 선택적 메서드의 기본 구현 제공
extension CustomViewControllerDelegate {
  func willAppear() {
    // 기본 구현은 아무것도 하지 않습니다
    // 델리게이트가 이 메서드를 꼭 구현할 필요가 없게 합니다
  }
}


// MARK: - 커스텀 뷰 컨트롤러 정의
class CustomViewController: UIViewController {

  // 델리게이트 속성 - weak 참조로 메모리 순환 참조 방지
  weak var delegate: CustomViewControllerDelegate?

  // 텍스트 필드와 버튼 속성
  private let textField = UITextField()
  private let actionButton = UIButton(type: .system)


  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 델리게이트에게 뷰가 나타날 것임을 알립니다
    delegate?.willAppear()
  }

  func setupUI() {
    view.backgroundColor = .white

    // 텍스트 필드 설정
    textField.borderStyle = .roundedRect
    textField.placeholder = "여기에 텍스트 입력"
    textField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(textField)

    // 버튼 설정
    actionButton.setTitle("전송", for: .normal)
    actionButton.addAction(UIAction { _ in
      self.buttonTapped()
    }, for: .touchUpInside)
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(actionButton)

    // 제약조건 설정
    NSLayoutConstraint.activate([
      textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
      textField.widthAnchor.constraint(equalToConstant: 250),

      actionButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
      actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])

  }

  private func buttonTapped() {
    // 버튼이 탭되면 델리게이트에게 알립니다
    let text = textField.text ?? ""
    delegate?.didTapButton(withText: text)
  }
}
