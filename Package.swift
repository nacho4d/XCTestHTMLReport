// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCTestHTMLReport",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "xchtmlreport", targets: ["XCTestHTMLReport"])
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/davidahouse/XCResultKit.git", .exact("0.7.1")),
        .package(url: "https://github.com/nacho4d/NDHpple.git", .exact("2.0.1-alpha1")),
    ],
    targets: [
        .target(
            name: "XCTestHTMLReport",
            dependencies: ["Rainbow", "XCResultKit"]),
        .testTarget(
            name: "XCTestHTMLReportTests",
            dependencies: ["XCTestHTMLReport", "NDHpple"],
            resources: [.copy("TestResults.xcresult")]),
    ]
)
