// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PasswordField",
    platforms: [
      .iOS(.v15),
      .macOS(.v12),
      .watchOS(.v8),
      // PasswordField is marked unavailable on tvOS,
      // but we still want to avoid breaking multi-platform projects,
      // so we must specify the minimum target so that the code builds.
      .tvOS(.v13)
    ],
    products: [
        .library(
            name: "PasswordField",
            targets: ["PasswordField"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PasswordField",
            dependencies: []),
        .testTarget(
            name: "PasswordFieldTests",
            dependencies: ["PasswordField"]),
    ]
)
