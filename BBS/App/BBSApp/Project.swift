import ProjectDescription

let project = Project(
    name: "BBSApp",
    targets: [
        .target(
            name: "BBSApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.BBSApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["BBSApp/Sources/**"],
            resources: ["BBSApp/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "BBSAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.BBSAppTests",
            infoPlist: .default,
            sources: ["BBSApp/Tests/**"],
            resources: [],
            dependencies: [.target(name: "BBSApp")]
        ),
    ]
)
