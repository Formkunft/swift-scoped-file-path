// swift-tools-version: 6.0
import PackageDescription

let package = Package(
	name: "swift-scoped-file-path",
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
			name: "ScopedFilePath",
			targets: ["ScopedFilePath"]),
	],
	targets: [
		.target(
			name: "ScopedFilePath"),
	]
)

#if !canImport(System)
package.dependencies.append(.package(url: "https://github.com/apple/swift-system", from: "1.3.0"))

package.targets[0].dependencies.append(.product(name: "SystemPackage", package: "swift-system"))
#endif
