//
//  MainViewController+CustomViewControllerDelegate.swift
//  DelegateDemo
//
//  Created by Jungman Bae on 3/13/25.
//

// MARK: - CustomViewControllerDelegate
extension MainViewController {
  func didTapButton(withText text: String) {
    print("버튼이 탭되었습니다. 텍스트: \(text)")
  }

  func willAppear() {
    print("CustomViewController가 나타날 예정입니다.")
  }
}
