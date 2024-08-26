// swift-tools-version: 5.10
import PackageDescription

let package = Package(
	name: "LightTableFilePaths",
	platforms: [
		.macOS(.v12),
		.iOS(.v15),
		.macCatalyst(.v15),
		.tvOS(.v15),
		.visionOS(.v1),
		.watchOS(.v8),
	],
	products: [
		.library(
			name: "LightTableFilePaths",
			targets: ["LightTableFilePaths"]),
	],
	targets: [
		.target(
			name: "LightTableFilePaths"),
		.testTarget(
			name: "LightTableFilePathsTests",
			dependencies: ["LightTableFilePaths"]),
	]
)

#if !canImport(System)
package.dependencies.append(.package(url: "https://github.com/apple/swift-system", from: "1.3.0"))

package.targets[0].dependencies.append(.product(name: "SystemPackage", package: "swift-system"))
#endif
