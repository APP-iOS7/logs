//
//  SecondViewController.swift
//  NavigationDemo
//
//  Created by Jungman Bae on 3/19/25.
//

import UIKit

class SecondViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "두 번째 뷰"

    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBlue
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.tintColor = .white // 아이템 색상
  }

}

#Preview {
  UINavigationController(rootViewController: ViewController())
}
