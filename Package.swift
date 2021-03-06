import PackageDescription

let package = Package(
    name: "stodo",
    targets: [
        Target(name: "StodoKit"),
        Target(name: "stodo",
              dependencies: [.Target(name: "StodoKit")]),
    ],
    dependencies: [
        .Package(url: "https://github.com/Carthage/Commandant.git", versions: Version(0, 12, 0)..<Version(0, 12, .max)),
    ]
)

