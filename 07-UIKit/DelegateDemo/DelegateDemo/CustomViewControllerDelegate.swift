//
//  CustomViewControllerDelegate.swift
//  DelegateDemo
//
//  Created by Jungman Bae on 3/13/25.
//

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

