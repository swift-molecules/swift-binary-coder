// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-binary-coder",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Binary Coder",
            targets: ["Binary Coder"]
        ),
        .library(
            name: "Binary Integer Coder",
            targets: ["Binary Integer Coder"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(
            url: "https://github.com/swift-molecules/swift-binary-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-witness.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-coder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-either.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership-shared.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Binary Coder",
            dependencies: [
                .product(
                    name: "Binary Input",
                    package: "swift-binary-parser"
                ),
                .product(
                    name: "Binary Machine",
                    package: "swift-binary-parser"
                ),
                .product(name: "Witness", package: "swift-witness"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Either", package: "swift-either"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear",
                    package: "swift-buffer-linear"
                ),
            ]
        ),
        .target(
            name: "Binary Integer Coder",
            dependencies: [
                "Binary Coder",
            ]
        ),
        .testTarget(
            name: "Binary Coder Tests",
            dependencies: [
                "Binary Coder",
                "Binary Integer Coder",
                .product(
                    name: "Binary Parser Test Support",
                    package: "swift-binary-parser"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
