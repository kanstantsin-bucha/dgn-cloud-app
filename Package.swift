// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "dgn-cloud-app",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .executable(name: "dgn-cloud-app", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent.git", from: "4.7.1"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.2.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.74.2"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.2.2")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
