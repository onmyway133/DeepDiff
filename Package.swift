// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DeepDiff",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v9),
        .tvOS(.v11),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "DeepDiff", targets: ["DeepDiff"]),
    ],
    targets: [
        .target(name: "DeepDiff", path: "Sources")
    ]
)
