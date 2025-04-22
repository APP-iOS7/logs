//
//  ViewController.swift
//  SnapKitDemo
//
//  Created by Jungman Bae on 4/22/25.
//
import UIKit
import SnapKit

class ViewController: UIViewController {

  private let redView = UIView()
  private let blueView = UIView()
  private let greenView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "SnapKit Demo"
    view.backgroundColor = .white
    setupViews()
    setupConstraints()
  }

  func setupViews() {
    redView.backgroundColor = .red
    blueView.backgroundColor = .blue
    greenView.backgroundColor = .green

    // Add subviews
    view.addSubview(redView)
    view.addSubview(blueView)
    view.addSubview(greenView)
  }

  func setupConstraints() {
    // 빨간 뷰 - 상단 좌측에 배치 (Safe Area 기준)
    redView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      make.leading.equalToSuperview().offset(20) // superview 여백 20
      make.width.height.equalTo(100)
    }

    // 파란 뷰 - 빨간 뷰 오른쪽에 배치
    blueView.snp.makeConstraints { make in
      make.top.equalTo(redView)
      make.trailing.equalToSuperview().offset(-20) // 빨간 뷰 오른쪽 여백 20
      make.width.height.equalTo(redView) // 빨간 뷰와 크기 동일하게
    }

    // 초록 뷰 - 두 뷰 아래, 화면 중앙에 배치
    greenView.snp.makeConstraints { make in
      make.top.equalTo(redView.snp.bottom).offset(20) // 빨간 뷰 아래 여백 20
      make.centerX.equalToSuperview() // 화면 중앙
      make.width.height.equalTo(150)
    }
  }

}


#Preview {
  UINavigationController(rootViewController: ViewController())
}
