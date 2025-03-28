//
//  RatingView.swift
//  JRNL
//
//  Created by Jungman Bae on 3/28/25.
//

import UIKit

class RatingView: UIStackView {
  // MARK: - Properties
  private var ratingButtons: [UIButton] = []
  var rating = 0 {
    didSet {
      updateButtonSelectionStates()
    }
  }
  private let buttonSize = CGSize(width: 44.0, height: 44.0)
  private let buttonCount = 5

  // MARK: - Initializer
  required init(coder: NSCoder) {
    super.init(coder: coder)
    setupButtons()
  }

  func setupButtons() {
    // 기존 버튼 제거
    for button in ratingButtons {
      removeArrangedSubview(button)
      button.removeFromSuperview()
    }
    ratingButtons.removeAll()

    // 버튼 이미지 설정
    let filledStar = UIImage(systemName: "star.fill")
    let emptyStar = UIImage(systemName: "star")
    let highlightedStar = UIImage(systemName: "star.fill")?.withTintColor(
      .red,
      renderingMode: .alwaysOriginal
    )

    // 버튼 생성
    for _ in 0..<buttonCount {
      let button = UIButton()
      button.setImage(emptyStar, for: .normal)
      button.setImage(filledStar, for: .selected)
      button.setImage(highlightedStar, for: .highlighted)
      button.setImage(highlightedStar, for: [.highlighted, .selected])

      // 버튼 제약 설정
      button.translatesAutoresizingMaskIntoConstraints = false
      button.heightAnchor.constraint(equalToConstant: buttonSize.height).isActive = true
      button.widthAnchor.constraint(equalToConstant: buttonSize.width).isActive = true

      // 버튼 액션 설정
      button.addAction(UIAction { [weak self] action in
        self?.ratingButtonTapped(button: button)
      }, for: .touchUpInside)

      // 스택뷰에 버튼 추가
      addArrangedSubview(button)

      // 버튼 배열에 추가
      ratingButtons.append(button)
    }

  }

  func ratingButtonTapped(button: UIButton) {
    guard let index = ratingButtons.firstIndex(of: button) else {
      fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
    }

    let selectedRating = index + 1

    if selectedRating == rating {
      rating = 0
    } else {
      rating = selectedRating
    }
  }

  func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
      button.isSelected = index < rating
    }
  }
}
