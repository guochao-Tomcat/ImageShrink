// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ImageShrink",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "ImageShrink",
            path: "Sources/ImageShrink"
        )
    ]
)
