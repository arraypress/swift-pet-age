// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-pet-age",
    platforms: [
        .macOS(.v14), .iOS(.v16), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1),
    ],
    products: [
        .library(name: "PetAge", targets: ["PetAge"]),
    ],
    targets: [
        .target(name: "PetAge"),
        .testTarget(name: "PetAgeTests", dependencies: ["PetAge"]),
    ]
)
