import ProjectDescription

let project = Project(
    name: "RxSwiftDemo",
    targets: [
        .target(
            name: "RxSwiftDemo",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.RxSwiftDemo",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["RxSwiftDemo/Sources/**"],
            resources: ["RxSwiftDemo/Resources/**"],
            dependencies: [
                .external(name: "RxSwift")
            ]
        ),
        .target(
            name: "RxSwiftDemoTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.RxSwiftDemoTests",
            infoPlist: .default,
            sources: ["RxSwiftDemo/Tests/**"],
            resources: [],
            dependencies: [.target(name: "RxSwiftDemo")]
        ),
    ]
)
