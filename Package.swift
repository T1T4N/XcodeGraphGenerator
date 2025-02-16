// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "XcodeGraphGenerator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "xcode-graph-mapper-cli",
            targets: ["XcodeGraphMapperCli"]
        ),
        .executable(
            name: "XcodeGraphGenerator",
            targets: ["XcodeGraphGenerator"]
        ),
        .library(
            name: "XcodeGraphGeneratorCore",
            targets: ["XcodeGraphGeneratorCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.74.0"),
        .package(url: "https://github.com/tuist/XcodeGraph.git", from: "1.5.17"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(
            name: "XcodeGraphMapperCli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "XcodeGraphMapper", package: "XcodeGraph"),
            ]
        ),
        .executableTarget(
            name: "XcodeGraphGenerator",
            dependencies: [
                "XcodeGraphGeneratorCore",
                "XcodeGraphGeneratorServer",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "XcodeGraphGeneratorCore",
            dependencies: [
                .product(name: "XcodeGraph", package: "XcodeGraph"),
            ]
        ),
        .target(
            name: "XcodeGraphGeneratorServer",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                "XcodeGraphGeneratorCore"
            ],
            resources: [
                .copy("Resources/public")
            ]
        )
    ]
)
