import ProjectDescription

let bundleId = "kr.co.codegrove.StoreApp"

let project = Project(
  name: "StoreApp",
  targets: [
    .target(
      name: "StoreApp",
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
      sources: ["StoreApp/Sources/**"],
      resources: ["StoreApp/Resources/**"],
      dependencies: [
        .external(name: "ComposableArchitecture"),
      ]
    ),
    .target(
      name: "StoreAppTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "\(bundleId).Tests",
      infoPlist: .default,
      sources: ["StoreApp/Tests/**"],
      resources: [],
      dependencies: [.target(name: "StoreApp")]
    ),
  ]
)
