
// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "JubaExpressSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "JubaExpressSDK",
            targets: ["JubaExpressSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "JubaExpressSDK",
            path: "Sources/Binary/JubaExpressSDK.xcframework"
        ),
    ]
)