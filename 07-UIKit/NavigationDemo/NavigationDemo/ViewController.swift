//
//  ViewController.swift
//  NavigationDemo
//
//  Created by Jungman Bae on 3/18/25.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "네비게이션 타이틀"

    // iOS 15 이상에서는 UINavigationBarAppearance 사용
    let appearance = UINavigationBarAppearance()
    // 투명한 배경 설정
    appearance.configureWithOpaqueBackground()
    // 배경색 설정
    appearance.backgroundColor = .systemBlue
    // 타이틀 색상
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

    // 네비게이션 바에 적용 (평상시)
    self.navigationController?.navigationBar.standardAppearance = appearance
    // 스와이프로 스크롤할 때
    self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    self.navigationController?.navigationBar.tintColor = .white // 아이템 색상
  }


}

