//
//  SignUpFormViewModel.swift
//  CombineDemo
//
//  Created by Jungman Bae on 4/7/25.
//
import Foundation
import Combine

enum UserNameValid {
  case valid
  case tooShort
  case notAvailable
}

typealias Available = Result<Bool, Error>

extension Publisher {
  func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    self
      .map(Result.success)
      .catch { error in Just(.failure(error)) }
      .eraseToAnyPublisher()
  }
}

class SignUpFormViewModel: ObservableObject {
  // 유저 입력 프로퍼티
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var passwordConfirmation: String = ""

  // 출력 프로퍼티
  @Published var usernameMessage: String = ""
  @Published var passwordMessage: String = ""
  @Published var isValid: Bool = false
  @Published var showUpdateDialog: Bool = false

  // Combine의 cancellables 프로퍼티
  private var cancellables: Set<AnyCancellable> = []

  var authenticationService = AuthenticationService()

  // 유저이름 유효성 검사 (3자 이상)
  private lazy var isUsernameLengthValidPublisher: AnyPublisher<Bool, Never> = {
    $username
      .map { $0.count >= 3 }
      .eraseToAnyPublisher()
  }()

  private lazy var isUsernameAvailablePublisher: AnyPublisher<Available, Never> = {
    $username
      .debounce(for: 0.8, scheduler: DispatchQueue.main)
      .removeDuplicates()
      .flatMap { username -> AnyPublisher<Available, Never> in
        return self.authenticationService
          .checkUserNameAvailablePublisher(userName: username)
          .asResult()
      }
      .receive(on: DispatchQueue.main)
      .share()
      .eraseToAnyPublisher()
  }()

  private lazy var isUsernameValidPublisher: AnyPublisher<UserNameValid, Never> = {
    Publishers.CombineLatest(isUsernameLengthValidPublisher, isUsernameAvailablePublisher)
      .map { isLengthValid, isAvailable in
        if !isLengthValid {
          return .tooShort
        } else if case .success(false) = isAvailable {
          return .notAvailable
        } else {
          return .valid
        }
      }
      .eraseToAnyPublisher()
  }()

  // 비밀번호 유효성 검사 (비밀번호가 비어있음을 검사)
  private lazy var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> = {
    $password
//      .map { $0.isEmpty } 을 다음과 같이 축약해서 사용할 수 있다.
      .map(\.isEmpty)
      .eraseToAnyPublisher()
  }()

  // 비밀번호와 비밀번호 확인 일치 검사
  private lazy var isPasswordMatchingPublisher: AnyPublisher<Bool, Never> = {
    Publishers.CombineLatest($password, $passwordConfirmation)
//      .map { $0 == $1 } 을 다음과 같이 축약해서 사용할 수 있다.
      .map(==)
      .eraseToAnyPublisher()
  }()

  // 위 두개의 비밀번호 검사 결과를 합쳐서 비밀번호 유효성 검사
  private lazy var isPasswordValidPublisher: AnyPublisher<Bool, Never> = {
    Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
    // 1. isPasswordEmptyPublisher가 true 이면 비밀번호가 비어있다는 뜻이므로 isValid가 false여야 한다.
    // 2. isPasswordMatchingPublisher가 true 이면 비밀번호와 비밀번호 확인이 일치한다는 뜻이므로 isValid가 true여야 한다.
      .map { !$0 && $1 }
      .eraseToAnyPublisher()
  }()

  private lazy var isFormValidPublisher: AnyPublisher<Bool, Never> = {
    Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
      .map { ($0 == .valid) && $1 }
      .eraseToAnyPublisher()
  }()

  init() {
    // dump 연산자 사용 예시
    Just(Date())
      .dump()
      .sink { _ in }
      .store(in: &cancellables)

    // 유저 이름 유효성 검사
    isUsernameAvailablePublisher
      .map { result in
        switch result {
        case .failure(let error):
          if case APIError.transportError(_) = error {
            return ""
          }
          else if case APIError.validationError(let reason) = error {
            return reason
          }
          else if case APIError.serverError(_, let reason, _) = error {
            return reason
          }
          else if case APIError.invalidResponse = error {
            return "서버 응답이 잘못되었습니다."
          }
          else if case APIError.invalidRequestError(let reason) = error {
            return reason
          }
          else if case APIError.decodingError(_) = error {
            return "서버 응답을 해석하는데 실패했습니다."
          }
          else {
            return error.localizedDescription
          }
        case .success(let isAvailable):
          return isAvailable ? "" : "사용할 수 없는 사용자 이름입니다."
        }
      }
      .assign(to: &$usernameMessage)

    // 디코딩 오류: 새 버전 다운로드를 제안하는
    // 오류 메시지 표시
    isUsernameAvailablePublisher
      .map { result in
        if case .failure(let error) = result {
          if case APIError.decodingError = error {
            return true
          }
        }
        return false
      }
      .assign(to: &$showUpdateDialog)

    // 비밀번호 유효성 검사
    Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
      .map { isEmpty, isMatching in
        if isEmpty {
          return "비밀번호를 입력하세요."
        } else if !isMatching {
          return "비밀번호가 일치하지 않습니다."
        } else {
          return ""
        }
      }
      .assign(to: &$passwordMessage)

    // 폼 유효성 검사
    isFormValidPublisher
      .assign(to: &$isValid)
  }
}
