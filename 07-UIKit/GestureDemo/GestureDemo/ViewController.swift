//
//  ViewController.swift
//  GestureDemo
//
//  Created by Jungman Bae on 3/18/25.
//

import UIKit

// MARK: - UIView extension (서브뷰 태그로 찾기 기능 추가)
extension UIView {
  func getSubview(withTag tag: Int) -> UIView? {
    return subviews.first(where: { $0.tag == tag })
  }
}

class ViewController: UIViewController {

  var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupGesture()
  }

  func setupUI() {
    imageView = UIImageView(image: UIImage(systemName: "star.fill"))
    imageView.tintColor = .systemBlue
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
    imageView.isUserInteractionEnabled = true
    view.addSubview(imageView)
  }

  func setupGesture() {
    // 여러 제스처 인식기 생성
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
    let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture))
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))

    // 제스처 인식기 추가
    imageView.addGestureRecognizer(pinchGesture)
    imageView.addGestureRecognizer(rotationGesture)
    imageView.addGestureRecognizer(panGesture)

    // Delegate 설정
    pinchGesture.delegate = self
    rotationGesture.delegate = self
    panGesture.delegate = self
  }

  @objc func handlePinchGesture(_ pinchGesture: UIPinchGestureRecognizer) {
    // 핀치 제스처 처리 코드
    guard let view = pinchGesture.view else { return }

    view.transform = view.transform.scaledBy(
      x: pinchGesture.scale,
      y: pinchGesture.scale
    )
    pinchGesture.scale = 1.0
  }

  @objc func handleRotationGesture(_ rotationGesture: UIRotationGestureRecognizer) {
    // 회전 제스처 처리 코드
    guard let view = rotationGesture.view else { return }

    view.transform = view.transform.rotated(by: rotationGesture.rotation)
    rotationGesture.rotation = 0
  }

  @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
    // 팬 제스처 처리 코드
    guard let view = panGesture.view else { return }

    let translation = panGesture.translation(in: view.superview)
    view.center.x += translation.x
    view.center.y += translation.y
    panGesture.setTranslation(.zero, in: view.superview)
  }
}

// MARK: - UIGestureRecognizerDelegate (동시 인식 설정)
extension ViewController: UIGestureRecognizerDelegate {
  // 동시 인식 설정
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true
  }

  // 특정 제스처를 다른 제스처보다 우선적으로 인식하도록 설정
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return gestureRecognizer is UIPinchGestureRecognizer && otherGestureRecognizer is UIRotationGestureRecognizer
  }
}

#Preview {
  ViewController()
}
