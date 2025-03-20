//
//  CustomCell.swift
//  TableViewDemo
//
//  Created by Jungman Bae on 3/20/25.
//

import UIKit

class CustomCell: UITableViewCell {
  // animalImageView: 동물의 이미지를 표시하는 UIImageView입니다.
  let animalImageView = UIImageView()
  // nameLabel: 동물의 이름을 표시하는 UILabel입니다.
  let nameLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    // 오른쪽 화살표를 표시하기 위해 accessoryType을 .disclosureIndicator로 설정합니다.
    accessoryType = .disclosureIndicator

    // 이미지 뷰의 크기와 위치를 설정합니다.
    // Auto Layout 제약 조건을 사용하기 위해 translatesAutoresizingMaskIntoConstraints를 false로 설정합니다.
    animalImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false

    // 셀의 contentView에 UI 요소들을 추가합니다.
    contentView.addSubview(animalImageView)
    contentView.addSubview(nameLabel)

    // Auto Layout 제약 조건을 설정합니다.
    NSLayoutConstraint.activate([
      // animalImageView의 제약 조건
      animalImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      animalImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      animalImageView.widthAnchor.constraint(equalToConstant: 50),
      animalImageView.heightAnchor.constraint(equalToConstant: 50),

      // nameLabel의 제약 조건
      nameLabel.leadingAnchor.constraint(equalTo: animalImageView.trailingAnchor, constant: 16),
      nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(image: UIImage, name: String) {
    animalImageView.image = image
    nameLabel.text = name
  }
}
