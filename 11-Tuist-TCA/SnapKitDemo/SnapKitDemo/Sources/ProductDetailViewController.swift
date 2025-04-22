//
//  ProductDetailViewController.swift
//  SnapKitDemo
//
//  Created by Jungman Bae on 4/22/25.
//

import UIKit
import SnapKit

class ProductDetailViewController: UIViewController {

  private let scrollView = UIScrollView()
  private let contentView = UIStackView()

  private let productImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "cart.circle.fill")
    imageView.tintColor = .systemBlue
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let productNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Product Name"
    label.font = UIFont.boldSystemFont(ofSize: 24)
    return label
  }()

  private let productPriceLabel: UILabel = {
    let label = UILabel()
    label.text = "$99.99"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textColor = .systemGreen
    return label
  }()

  private let productDescriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "Product description goes here."
    label.font = UIFont.systemFont(ofSize: 16)
    // 여러줄 설정
    label.numberOfLines = 0
    return label
  }()

  private let addToCartButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Add to Cart", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Product Detail"

    setupUI()
    setupConstraints()
  }

  func setupUI() {
    view.backgroundColor = .white

    // ScrollView 설정
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)

    // StackView 설정
    contentView.axis = .vertical
    contentView.spacing = 200
    contentView.alignment = .fill
    contentView.distribution = .fill

    // Add subviews to StackView
    contentView.addArrangedSubview(productImageView)
    contentView.addArrangedSubview(productNameLabel)
    contentView.addArrangedSubview(productPriceLabel)
    contentView.addArrangedSubview(productDescriptionLabel)
    view.addSubview(addToCartButton)
  }

  func setupConstraints() {
    // ScrollView Constraints
    scrollView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide) // Safe Area 기준으로 상하 맞춤
      make.bottom.equalTo(addToCartButton.snp.top).offset(-20) // Add to Cart 버튼 위에 위치
    }

    // Add to Cart Button Constraints
    addToCartButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20) // 좌우 여백 20
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20) // Safe Area 기준으로 20 포인트 여백
      make.height.equalTo(50)
    }

    // ContentView Constraints
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview() // ScrollView의 edges에 맞춤
      make.width.equalTo(scrollView)
    }

    // Product ImageView Constraints
    productImageView.snp.makeConstraints { make in
      make.size.equalTo(200)
      make.leading.trailing.equalToSuperview().inset(20) // 좌우 여백 20
    }

    // Product Name Label Constraints
    productNameLabel.snp.makeConstraints { make in
      make.top.equalTo(productImageView.snp.bottom).offset(16)
      make.leading.trailing.equalTo(productImageView) // 이미지와 좌우 정렬
    }



  }




}


#Preview {
  UINavigationController(rootViewController: ProductDetailViewController())
}
