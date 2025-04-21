import ProjectDescription

let bundleId = "kr.co.codegrove.HelloTuist"

let appTarget = Target.target(
  name: "HelloTuist",
  destinations: .iOS,
  product: .app,
  bundleId: bundleId,
  infoPlist: .extendingDefault(
    with: [
      "UILaunchScreen": [
        "UIColorName": "",
        "UIImageName": "",
      ],
    ]
  ),
  sources: ["HelloTuist/Sources/**"],
  resources: ["HelloTuist/Resources/**"],
  dependencies: [
    .target(name: "ProductFeature")
  ]
)

let testTarget = Target.target(
  name: "HelloTuistTests",
  destinations: .iOS,
  product: .unitTests,
  bundleId: "io.tuist.HelloTuistTests",
  infoPlist: .default,
  sources: ["HelloTuist/Tests/**"],
  resources: [],
  dependencies: [.target(name: "HelloTuist")]
)

// MARK: - Modules
let productFeatureModule = Target.target(
  name: "ProductFeature",
  destinations: .iOS,
  product: .framework, // App에서 사용할 것이므로 framework
  bundleId: "\(bundleId).ProductFeature",
  infoPlist: .default,
  sources: ["Modules/ProductFeature/Sources/**"],
  dependencies: [
    .target(name: "Network") // Network 모듈의 APIService, Product 모델 사용
  ]
)


let networkModule = Target.target(
  name: "Network",
  destinations: .iOS,
  product: .framework, // 다른 모듈에서 사용할 것이므로 framework로 설정
  bundleId: "\(bundleId).Network",
  infoPlist: .default,
  sources: ["Modules/Network/Sources/**"],
  dependencies: [
    .package(product: "Alamofire"),
  ]
)

let networkTests = Target.target(
  name: "NetworkTests",
  destinations: .iOS,
  product: .unitTests,
  bundleId: "\(bundleId).NetworkTests",
  infoPlist: .default,
  sources: ["Modules/Network/Tests/**"],
  dependencies: [
    .target(name: "Network") // Network 모듈 테스트
  ]
)


let project = Project(
  name: "HelloTuist",
  targets: [
    appTarget,
    testTarget,
    productFeatureModule,
    networkModule,
    networkTests
  ]
)
