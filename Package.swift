// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "KIF",
    platforms: [
        .iOS(.v9)
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
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("ApplePrivateAPIs/"),
                .headerSearchPath("Additions/"),
                .headerSearchPath("Classes/"),
                .headerSearchPath("Visualizer/"),
                .headerSearchPath("IdentifierTests/"),
            ],
            linkerSettings: [.linkedFramework("IOKit")]
        ),
        .testTarget(
            name: "KIFTests",
            dependencies: ["KIF"],
            path: "./KIF Tests",
            cSettings: [.headerSearchPath("../Sources/KIF/")] // allow to look a "private" headers
        ),
    ]
)
