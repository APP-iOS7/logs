//
//  AnimationViewController.swift
//  SnapKitDemo
//
//  Created by Jungman Bae on 4/22/25.
//

import UIKit

class AnimationViewController: UIViewController {

  private let animationImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "cart.circle.fill")
    imageView.tintColor = .systemBlue
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let animateButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Animate", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()

  private var isExpanded = false

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Animation Demo"
    view.backgroundColor = .white
    setupUI()
  }

  func setupUI() {
    view.addSubview(animationImageView)
    view.addSubview(animateButton)

    animationImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-50)
      make.width.height.equalTo(100)
    }

    animateButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview().offset(50)
      make.centerX.equalToSuperview()
      make.width.equalTo(200)
      make.height.equalTo(50)
    }

    animateButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      self.animateImageView()
    }, for: .touchUpInside)
  }

  func animateImageView() {
    isExpanded.toggle()

    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: [.curveEaseInOut],
                   animations: {
      self.animationImageView.snp.updateConstraints { make in
        make.size.equalTo(self.isExpanded ? 200 : 100)
      }

      self.animateButton.snp.updateConstraints { make in
        make.centerY.equalToSuperview().offset(self.isExpanded ? 100 : 50)
      }

      // 즉각적으로 레이아웃 업데이트
      self.view.layoutIfNeeded()

      // 추가적인 시각적 변경 (배경색 등)
      self.animationImageView.tintColor = self.isExpanded ? .systemGreen : .systemBlue

    }, completion: nil)
  }
}


#Preview {
  UINavigationController(rootViewController: AnimationViewController())
}
