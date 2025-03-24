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
    UIView.animate(withDuration: 1, animations: {
      self.animationView.transform = self.animationView.transform.rotated(by: .pi / 4)
    }, completion: { _ in
      UIView.animate(withDuration: 1) {
        self.animationView.backgroundColor = .systemBlue
      } completion: { _ in
        UIView.animate(withDuration: 1) {
//          self.animationView.frame.origin.x += 50
//          self.animationView.frame.origin.y += 10
        } completion: { _ in
          // 현재 상태에 따라 확대 또는 축소
          if self.animationView.transform == .identity {
            UIView.animate(withDuration: 1.0) {
              self.animationView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }
          } else {
            UIView.animate(withDuration: 1.0) {
              self.animationView.transform = .identity
            }
          }
        }
      }
    })
  }
}

#Preview {
  ViewController()
}
