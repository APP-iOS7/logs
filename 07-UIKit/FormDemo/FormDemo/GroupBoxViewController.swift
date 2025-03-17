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

    groupBoxLabel.text = "그룹 박스"
    groupBoxLabel.font = .systemFont(ofSize: 20)
    groupBoxLabel.translatesAutoresizingMaskIntoConstraints = false
    groupBox.addSubview(groupBoxLabel)

    toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    toggle.translatesAutoresizingMaskIntoConstraints = false
    groupBox.addSubview(toggle)

    textField.borderStyle = .roundedRect
    textField.placeholder = "텍스트 필드"
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false
    groupBox.addSubview(textField)

    NSLayoutConstraint.activate([
      groupBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      groupBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      groupBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      groupBox.heightAnchor.constraint(equalToConstant: 200),

      groupBoxLabel.topAnchor.constraint(equalTo: groupBox.topAnchor, constant: 20),
      groupBoxLabel.leadingAnchor.constraint(equalTo: groupBox.leadingAnchor, constant: 10),

      toggle.topAnchor.constraint(equalTo: groupBoxLabel.bottomAnchor, constant: 10),
      toggle.leadingAnchor.constraint(equalTo: groupBox.leadingAnchor, constant: 10),

      textField.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: 10),
      textField.leadingAnchor.constraint(equalTo: groupBox.leadingAnchor, constant: 10),
      textField.trailingAnchor.constraint(equalTo: groupBox.trailingAnchor, constant: -10),
      textField.bottomAnchor.constraint(equalTo: groupBox.bottomAnchor, constant: -10)
    ])
  }

  @objc func toggleChanged() {
    flag = toggle.isOn
    print("flag: \(flag)")
    // 텍스트 필드 편집 종료
    textField.resignFirstResponder()
  }
}

extension GroupBoxViewController: UITextFieldDelegate {
  // 편집 가능 여부 결정
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return flag
  }

  // 텍스트 필드 편집 시작
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("편집 시작")
  }

  // 텍스트 필드 문자 입력
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

    print("실제 입력 값: \(string)")
    print("현재 텍스트 필드 값: \(currentText)")
    print("최종 업데이트 텍스트: \(updatedText)")

    return true
  }

  // 필드 편집 종료
  func textFieldDidEndEditing(_ textField: UITextField) {
    print("편집 종료")
  }
}

#Preview {
  GroupBoxViewController()
}

