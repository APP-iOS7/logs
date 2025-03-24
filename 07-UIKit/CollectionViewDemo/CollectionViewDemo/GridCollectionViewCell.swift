//
//  GridCollectionViewCell.swift
//  CollectionViewDemo
//
//  Created by Jungman Bae on 3/24/25.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
  // MARK: - Properties
  static let identifier = "GridCollectionViewCell"

  // 이미지를 표시하는 UIImageView
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .systemBlue
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  // 제목을 표시하는 UILabel
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // 셀 배경을 위한 컨테이너 뷰
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray6
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupLayout() {
    contentView.addSubview(containerView)
    containerView.addSubview(imageView)
    containerView.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      // 컨테이너 뷰 제약조건
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

      // 이미지 뷰 제약조건
      imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 50),
      imageView.heightAnchor.constraint(equalToConstant: 50),

      // 레이블 제약조건
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
      titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
    ])
  }

  // MARK: - Configure
  func configure(with item: GridItem) {
    imageView.image = UIImage(systemName: item.imageSystemName)
    titleLabel.text = item.title
  }

  // 셀 재사용 준비
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    titleLabel.text = nil
  }
}
