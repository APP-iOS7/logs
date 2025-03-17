//
//  ViewController.swift
//  ImageDemo
//
//  Created by Jungman Bae on 3/17/25.
//

import UIKit

class ViewController: UIViewController {

  let scrollView = UIScrollView()
  let stackView = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // UI 설정 (기본 스크롤과 스택 뷰 추가)
    setupUI()

    // 기본 도형 표시
    setupShapes()

    // 이미지 표시
    setupImages()

    // 이미지 컨텐츠 모드
    setupImageContentMode()

    // SF Symbol 표시
    setupSFSymbols()
  }

  // MARK: - UI 설정 (기본 스크롤과 스택 뷰 추가)
  func setupUI() {
    // 스크롤 뷰 설정
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)

    // 스택 뷰 설정
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(stackView)

    // 제약조건 설정
    NSLayoutConstraint.activate([
      // 스크롤 뷰 제약조건 설정
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      // 스택 뷰 제약조건 설정
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),

      // 중요: 스택 뷰의 너비를 스크롤 뷰의 너비에 맞춤 (패딩 고려)
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
    ])
  }

  // MARK: - 기본 도형 표시
  func setupShapes() {
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false

    // 제목 레이블
    let titleLabel = UILabel()
    titleLabel.text = "1. 기본 도형"
    titleLabel.font = .systemFont(ofSize: 24)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(titleLabel)

    // 원 만들기
    let circleView = UIView()
    // 크기에 대한 컨텍스트 상수
    let circleSize: CGFloat = 80

    circleView.translatesAutoresizingMaskIntoConstraints = false
    circleView.backgroundColor = .yellow
    circleView.layer.cornerRadius = circleSize / 2
    circleView.layer.borderWidth = 2
    circleView.layer.borderColor = UIColor.black.cgColor
    containerView.addSubview(circleView)

    // 사각형 만들기
    let squareView = UIView()
    let squareSize: CGFloat = 80

    squareView.translatesAutoresizingMaskIntoConstraints = false
    squareView.backgroundColor = .blue
    containerView.addSubview(squareView)

    // 스택 뷰에 컨테이너 뷰 추가
    stackView.addArrangedSubview(containerView)

    // 제목 레이블, 원, 사각형의 제약조건 설정
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

      circleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      circleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      circleView.widthAnchor.constraint(equalToConstant: circleSize),
      circleView.heightAnchor.constraint(equalToConstant: circleSize),

      squareView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      squareView.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 30),
      squareView.widthAnchor.constraint(equalToConstant: squareSize),
      squareView.heightAnchor.constraint(equalToConstant: squareSize),

      // 중요: 컨테이너 뷰의 높이 명시적으로 설정 (마지막 요소 기준)
      containerView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 20)
    ])

  }

  // MARK: - 이미지 표시
  func setupImages() {
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false

    // 제목 레이블
    let titleLabel = UILabel()
    titleLabel.text = "2. 이미지 표시"
    titleLabel.font = .systemFont(ofSize: 24)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(titleLabel)

    // 이미지 뷰 생성
    let imageView = UIImageView()
    imageView.image = UIImage(named: "car")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(imageView)

    // 스택 뷰에 컨테이너 뷰 추가
    stackView.addArrangedSubview(containerView)

    // 제목 레이블, 이미지 뷰의 제약조건 설정
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

      imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 200),

      // 중요: 컨테이너 뷰의 높이 명시적으로 설정 (마지막 요소 기준)
      containerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
    ])
  }

  // MARK: - 이미지 컨텐츠 모드
  func setupImageContentMode() {
    addImageContentModeWith(title: "3. 이미지 컨텐츠 모드 (aspectFill)", contentMode: .scaleAspectFill)

    addImageContentModeWith(title: "4. 이미지 컨텐츠 모드 (aspectFit)", contentMode: .scaleAspectFit)

    addImageContentModeWith(title: "5. 이미지 컨텐츠 모드 (scaleToFill)", contentMode: .scaleToFill)
  }

  // 이미지 컨텐츠 모드 추가
  func addImageContentModeWith(title: String, contentMode: UIView.ContentMode) {
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .systemFont(ofSize: 24)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(titleLabel)

    let imageView = UIImageView()
    imageView.image = UIImage(named: "car")
    imageView.backgroundColor = .black
    imageView.contentMode = contentMode
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(imageView)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

      imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 100),

      containerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
    ])

    stackView.addArrangedSubview(containerView)
  }

  // MARK: - SF Symbol 표시
  func setupSFSymbols() {
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false

    // 제목 레이블
    let titleLabel = UILabel()
    titleLabel.text = "6. SF Symbol 표시"
    titleLabel.font = .systemFont(ofSize: 24)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(titleLabel)

    // SF Symbol 이미지 뷰 생성
    if #available(iOS 13.0, *) {
      let imageView = UIImageView()
      let configuration = UIImage.SymbolConfiguration(pointSize: 100)
      imageView.image = UIImage(systemName: "hare.fill", withConfiguration: configuration)
      imageView.tintColor = .purple
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview(imageView)

      // 스택 뷰에 컨테이너 뷰 추가
      stackView.addArrangedSubview(containerView)

      // 제목 레이블, 이미지 뷰의 제약조건 설정
      NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        imageView.heightAnchor.constraint(equalToConstant: 100),

        // 중요: 컨테이너 뷰의 높이 명시적으로 설정 (마지막 요소 기준)
        containerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
      ])
    }
  }
}

#Preview {
  ViewController()
}

