//
//  SignUpFormViewModel.swift
//  CombineDemo
//
//  Created by Jungman Bae on 4/7/25.
//
import Foundation
import Combine

class SignUpFormViewModel: ObservableObject {
  // 유저 입력 프로퍼티
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var passwordConfirmation: String = ""

  // 출력 프로퍼티
  @Published var usernameMessage: String = ""
  @Published var passwordMessage: String = ""
  @Published var isValid: Bool = false

  private lazy var isUsernameLengthValidPublisher: AnyPublisher<Bool, Never> = {
    $username
      .map { $0.count >= 3 }
      .eraseToAnyPublisher()
  }()


  init() {
    isUsernameLengthValidPublisher
      .assign(to: &$isValid)

    // 유저 이름 유효성 검사
    isUsernameLengthValidPublisher
      .map { $0 ? "" : "사용자 이름은 3자 이상이어야 합니다." }
      .assign(to: &$usernameMessage)
  }
}
