// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "flowkit-ios",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "flowkit-ios",
            targets: ["flowkit-ios"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.1.0"),
    ],
    targets: [
        .target(
            name: "flowkit-ios",
            path: "flowkit-ios/Classes"
        ),
        .testTarget(
            name: "flowkit-ios-Tests",
            dependencies: ["flowkit-ios", "Quick", "Nimble"],
            path: "flowkit-ios/Tests"
        )
    ]
)