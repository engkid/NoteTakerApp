// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "DailyReminder",
  platforms: [ .iOS(.v17) ],
  products: [
    .library(name: "Domain", targets: ["Domain"]),
    .library(name: "Persistence", targets: ["Persistence"]),
    .library(name: "Notifications", targets: ["Notifications"]),
    .library(name: "Background", targets: ["Background"]),
    .library(name: "DI", targets: ["DI"]),
    .library(name: "SharedKit", targets: ["SharedKit"]),
    .library(name: "AppFeature", targets: ["AppFeature"])
  ],
  dependencies: [
    .package(url: "https://github.com/hmlongco/Factory.git", from: "2.4.0"),
    .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0")
  ],
  targets: [
    .target(name: "Domain", dependencies: [], path: "Sources/Domain"),
    .target(name: "SharedKit", dependencies: [.product(name: "Collections", package: "swift-collections")], path: "Sources/SharedKit"),
    .target(name: "Persistence", dependencies: ["Domain","SharedKit"], path: "Sources/Persistence"),
    .target(name: "Notifications", dependencies: ["Domain","SharedKit"], path: "Sources/Notifications"),
    .target(name: "Background", dependencies: ["Domain","Notifications","SharedKit"], path: "Sources/Background"),
    .target(name: "DI", dependencies: ["Domain","Persistence","Notifications","Background","SharedKit","Factory"], path: "Sources/DI"),
    .target(name: "AppFeature", dependencies: ["Domain","DI","Factory"], path: "Sources/AppFeature"),
    .testTarget(name: "DomainTests", dependencies: ["Domain","SharedKit"], path: "Tests/DomainTests"),
    .target(name: "TestSupport", dependencies: ["Domain"], path: "Tests/TestSupport")
  ]
)
