import ProjectDescription

let project = Project(
    name: "Ddanzi-iOS",
    targets: [
        .target(
            name: "Ddanzi-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.orangeCo.Ddanzi-iOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["Ddanzi-iOS/Sources/**"],
            resources: ["Ddanzi-iOS/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "Ddanzi-iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.orangeCo.Ddanzi-iOSTests",
            infoPlist: .default,
            sources: ["Ddanzi-iOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Ddanzi-iOS")]
        ),
    ]
)
