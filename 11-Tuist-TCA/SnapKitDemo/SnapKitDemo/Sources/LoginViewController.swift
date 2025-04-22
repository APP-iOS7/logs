//
//  LoginViewController.swift
//  SnapKitDemo
//
//  Created by Jungman Bae on 4/22/25.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

  private let loginImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "cart.circle.fill")
    imageView.tintColor = .systemBlue
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "이메일 주소"
    textField.borderStyle = .roundedRect
    textField.layer.borderWidth = 2
    textField.layer.borderColor = UIColor.systemGray3.cgColor
    textField.layer.cornerRadius = 5
    textField.keyboardType = .emailAddress
    // 자동 대문자 비활성화
    textField.autocapitalizationType = .none
    // 자동 맞춤법 검사 비활성화
    textField.autocorrectionType = .no
    return textField
  }()

  private let passwordField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "비밀번호"
    textField.borderStyle = .roundedRect
    textField.layer.borderWidth = 2
    textField.layer.borderColor = UIColor.systemGray3.cgColor
    textField.layer.cornerRadius = 5
    textField.isSecureTextEntry = true
    return textField
  }()

  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("로그인", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()

  private let forgotPasswordButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("비밀번호를 잊으셨나요?", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    setupUI()
  }

  func setupUI() {
    view.backgroundColor = .white

    // Add subviews
    view.addSubview(loginImageView)
    view.addSubview(emailTextField)
    view.addSubview(passwordField)
    view.addSubview(loginButton)
    view.addSubview(forgotPasswordButton)

    // Set constraints using SnapKit
    loginImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide).offset(100) // Safe Area 기준으로 100 포인트 아래
      make.size.equalTo(120) // Set width and height to 100 points
    }

    emailTextField.snp.makeConstraints { make in
      make.top.equalTo(loginImageView.snp.bottom).offset(50) // 이미지 뷰 아래 여백 50
      make.leading.trailing.equalToSuperview().inset(30) // 좌우 여백 20
      make.height.equalTo(44) // 높이 44 포인트
    }

    passwordField.snp.makeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom).offset(20) // 이메일 필드 아래 여백 20
      make.leading.trailing.height.equalTo(emailTextField) // 이메일 필드와 동일한 크기
    }

    loginButton.snp.makeConstraints { make in
      make.top.equalTo(passwordField.snp.bottom).offset(30) // 비밀번호 필드 아래 여백 30
      make.leading.trailing.height.equalTo(emailTextField) // 이메일 필드와 동일한 크기
    }

    forgotPasswordButton.snp.makeConstraints { make in
      make.top.equalTo(loginButton.snp.bottom).offset(15) // 로그인 버튼 아래 여백 15
      make.centerX.equalToSuperview() // 화면 중앙
    }

  }
}

#Preview {
  UINavigationController(rootViewController: LoginViewController())
}
