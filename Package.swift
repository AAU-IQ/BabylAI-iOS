// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BabylAI-iOS",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "BabylAI", targets: ["BabylAI"])
    ],
    dependencies: [
        .package(url: "https://github.com/ably/ably-cocoa", from: "1.2.41"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2")
    ],
    targets: [
        .binaryTarget(name: "BabylAI", path: "Sources/BabylAI-iOS/BabylAI.xcframework")
    ]
)
