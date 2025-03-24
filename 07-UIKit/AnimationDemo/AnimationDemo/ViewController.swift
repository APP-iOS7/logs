//
//  ViewController.swift
//  AnimationDemo
//
//  Created by Jungman Bae on 3/24/25.
//

import UIKit

class ViewController: UIViewController {

  let animationView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    configureAnimationView()
    configureButton()
  }

  func configureAnimationView() {
    animationView.frame = CGRect(x: 50, y: 100, width: 100, height: 100)
    animationView.backgroundColor = .systemRed
    animationView.layer.cornerRadius = 8
    view.addSubview(animationView)
  }

  func configureButton() {
    let button = UIButton(type: .system)
    button.setTitle("Start Animation", for: .normal)

    button.addAction(UIAction(handler: { [weak self] _ in
      self?.startAnimation()
    }), for: .touchUpInside)

    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)

    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20)
    ])
  }

  func startAnimation() {
    UIView.animate(withDuration: 1.0) {
      self.animationView.frame.origin.x += 100
      self.animationView.frame.origin.y += 50
    }
  }
}

#Preview {
  ViewController()
}
