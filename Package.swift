// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KIF",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "KIF",
            targets: ["KIF"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "KIF",
            dependencies: [],
            cSettings: [.headerSearchPath("ApplePrivateAPIs/")],
            linkerSettings: [.linkedFramework("IOKit")]),
        .testTarget(
            name: "KIFTests",
            dependencies: ["KIF"],
            path: "./KIF Tests",
            cSettings: [.headerSearchPath("../Sources/KIF/")]), // allow to look a "private" headers
    ]
)
