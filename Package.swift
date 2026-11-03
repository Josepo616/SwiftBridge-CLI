// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftBridge",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "SwiftBridgeCore", targets: ["SwiftBridgeCore"]),
    ],
    targets: [
        .target(
            name: "SwiftBridgeCore"
        ),
        .testTarget(
            name: "SwiftBridgeCoreTests",
            dependencies: ["SwiftBridgeCore"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
