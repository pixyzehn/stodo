import PackageDescription

let package = Package(
    name: "stodo",
    targets: [
        Target(name: "StodoKit"),
        Target(name: "stodo",
              dependencies: [.Target(name: "StodoKit")]),
    ],
    dependencies: [
        .Package(url: "https://github.com/Carthage/Commandant.git", versions: Version(0, 11, 3)..<Version(0, 11, .max)),
        .Package(url: "https://github.com/Quick/Nimble", majorVersion: 5, minorVersion: 1),
        .Package(url: "https://github.com/Quick/Quick", majorVersion: 1),
    ]
)

