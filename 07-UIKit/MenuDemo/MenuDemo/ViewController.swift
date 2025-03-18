//
//  ViewController.swift
//  MenuDemo
//
//  Created by Jungman Bae on 3/18/25.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func setupUI() {
    // 디폴트 버튼 설정
    var config = UIButton.Configuration.plain()

    // 밑줄 스타일
    let attributedTitle = AttributedString("메뉴 열기")
    var container = AttributeContainer()
    container.underlineStyle = [.single]
    container.underlineColor = .systemBlue
    container.font = .systemFont(ofSize: 50)

    let underlinedTitle = attributedTitle.settingAttributes(container)
    config.attributedTitle = underlinedTitle

    // 버튼 생성
    let button = UIButton(configuration: config)
    button.addAction(UIAction { [weak self] _ in
      print("버튼 클릭")
      self?.showMenu()
    }, for: .touchUpInside)

    button.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(button)

    // 제약조건 설정
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  func showMenu() {
    let alert = UIAlertController(title: "메뉴", message: "메뉴를 선택하세요", preferredStyle: .actionSheet)

    // 클로저를 직접 사용하는 방식으로 변경
    alert.addAction(UIAlertAction(title: "Open", style: .default) { [weak self] _ in
      self?.showMessage("Open 선택됨")
    })

    alert.addAction(UIAlertAction(title: "Find", style: .default) { [weak self] _ in
      self?.showMessage("Find 선택됨")
    })

    alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
      self?.showMessage("Delete 선택됨")
    })

    // 취소 액션 추가 ( 외부 탭 닫힘도 같이 동작함 )
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    // 아이패드에서 팝오버 형태로 메뉴를 표시하기 위한 설정입니다.
    if let popoverController = alert.popoverPresentationController {
      popoverController.sourceView = view
      popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
      popoverController.permittedArrowDirections = [.down]
    }

    // 액션 시트를 표시합니다.
    present(alert, animated: true)
  }

  private func showMessage(_ message: String) {
    // UIAlertController를 사용하여 알림을 생성합니다.
    let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    // "OK" 액션을 추가합니다.
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    // 알림을 표시합니다.
    present(alert, animated: true)
  }


  private func openLink() {
    if let url = URL(string: "https://www.apple.com"),
       UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url) { success in
        if success {
          print("웹사이트 열기 성공")
        } else {
          print("웹사이트 열기 실패")
        }
      }
    }
  }
}

#Preview {
  ViewController()
}
