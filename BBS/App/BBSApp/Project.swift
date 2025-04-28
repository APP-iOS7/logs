import ProjectDescription

let bundleId = "kr.co.codegrove.BBSApp"

let project = Project(
  name: "BBSApp",
  settings: .settings(
    base: [
      "OTHER_LDFLAGS": ["-ObjC"]
    ]
  ),
  targets: [
    .target(
      name: "BBSApp",
      destinations: .iOS,
      product: .app,
      bundleId: bundleId,
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
          "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true,
          ],
        ]
      ),
      sources: ["BBSApp/Sources/**"],
      resources: ["BBSApp/Resources/**"],
      dependencies: [
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseCrashlytics"),
        .external(name: "FirebaseCore"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseStorage"),
      ]
    ),
    .target(
      name: "BBSAppTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "\(bundleId).Tests",
      infoPlist: .default,
      sources: ["BBSApp/Tests/**"],
      resources: [],
      dependencies: [.target(name: "BBSApp")]
    ),
  ]
)
