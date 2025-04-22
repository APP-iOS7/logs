import ProjectDescription

let bundleIdPrefix = "kr.co.codegrove.SnapKitDemo"

let project = Project(
  name: "SnapKitDemo",
  targets: [
    .target(
      name: "SnapKitDemo",
      destinations: .iOS,
      product: .app,
      bundleId: "\(bundleIdPrefix)",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      sources: ["SnapKitDemo/Sources/**"],
      resources: ["SnapKitDemo/Resources/**"],
      dependencies: [
        .external(name: "SnapKit"),
      ]
    ),
    .target(
      name: "SnapKitDemoTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "\(bundleIdPrefix).Tests",
      infoPlist: .default,
      sources: ["SnapKitDemo/Tests/**"],
      resources: [],
      dependencies: [.target(name: "SnapKitDemo")]
    ),
  ]
)
