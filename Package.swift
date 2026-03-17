// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TrueLayerWebViewSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "TrueLayerWebViewSDK",
            targets: ["TrueLayerWebViewSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "TrueLayerWebViewSDK",
            path: "TrueLayerWebViewSDK.xcframework"
        )
    ]
)
