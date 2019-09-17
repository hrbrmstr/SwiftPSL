// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPSL",
    dependencies: [
    ],
    targets: [
        .systemLibrary(name: "psl", pkgConfig: "libpsl"),
        .target(name: "SwiftPSL", dependencies: ["psl"]),
        .target(name: "psl-app", dependencies: ["SwiftPSL"]),
        .testTarget(name: "SwiftPSLTests", dependencies: ["SwiftPSL"])
    ]
)
