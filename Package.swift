import PackageDescription

let package = Package(
    name: "stodo",
    dependencies: [
		.Package(url: "https://github.com/Carthage/Commandant.git", versions: Version(0, 11, 3)..<Version(0, 11, .max)),
    ]
)

