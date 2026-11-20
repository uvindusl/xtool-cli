// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "{{APP_NAME}}",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
        .library(
            name: "{{APP_NAME}}",
            targets: ["{{APP_NAME}}"]
        ),
    ],
    targets: [
        .target(
            name: "{{APP_NAME}}",
            path: "Sources/{{APP_NAME}}"
        ),
    ]
)