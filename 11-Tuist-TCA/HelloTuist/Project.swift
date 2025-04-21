import ProjectDescription

let appTarget = Target.target(
  name: "HelloTuist",
  destinations: .iOS,
  product: .app,
  bundleId: "io.tuist.HelloTuist",
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
    .package(product: "Alamofire"),
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


let project = Project(
  name: "HelloTuist",
  targets: [
    appTarget,
    testTarget
  ]
)
