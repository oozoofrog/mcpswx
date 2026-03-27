// swift-tools-version: 6.2
// swiftmcp — Swift MCP 플랫폼 런타임/패키지 러너
// Python uvx / Node.js npx에 대응하는 Swift 전용 MCP 서버 도구

import PackageDescription

let package = Package(
    name: "swiftmcp",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        // 유일한 외부 의존성: CLI 파싱
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.3.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "swiftmcp",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/swiftmcp",
            swiftSettings: [
                // Swift 6 strict concurrency 모드 활성화
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
