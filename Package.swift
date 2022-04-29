// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "N26FlowKitCore",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "N26FlowKitCore",
            targets: ["N26FlowKitCore"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.2.1"),
    ],
    targets: [
        .target(
            name: "N26FlowKitCore",
            path: "flowkit-ios/Classes"
        ),
        .testTarget(
            name: "flowkit-ios-Tests",
            dependencies: ["N26FlowKitCore", "Quick", "Nimble"],
            path: "flowkit-ios/Tests"
        )
    ]
)