// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "ShotKickKit",
  defaultLocalization: "en",
  platforms: [.macOS(.v15)],
  products: [
    .library(name: "ShotKickKit", targets: ["ShotKickKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: Version(1, 3, 1)),
    .package(url: "https://github.com/MacroFactor/apple-shortcuts", from: Version(1, 1, 0))
  ],
  targets: [
    .target(
      name: "ShotKickKit",
      dependencies: [
        .product(name: "Nutrition", package: "apple-shortcuts"),
        .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
      ]
    ),
  ]
)
