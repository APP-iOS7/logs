import ProjectDescription

let project = Project(
    name: "TCADemo",
    targets: [
        .target(
            name: "TCADemo",
            destinations: .iOS,
            product: .app,
            bundleId: "kr.co.codegrove.TCADemo",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    // 모든 HTTP 연결을 허용
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true,
                    ],
                ]
            ),
            sources: ["TCADemo/Sources/**"],
            resources: ["TCADemo/Resources/**"],
            dependencies: [
              .external(name: "ComposableArchitecture"),
            ]
        ),
        .target(
            name: "TCADemoTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "kr.co.codegrove.TCADemoTests",
            infoPlist: .default,
            sources: ["TCADemo/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TCADemo")]
        ),
    ]
)
