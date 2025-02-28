# Swift Scoped File Path

A Swift package introducing separate `AbsoluteFilePath` and `RelativeFilePath` based on `FilePath` from [Swift System](https://github.com/apple/swift-system).

## Using Swift Scoped File Path in your project

Add `swift-scoped-file-path` as a dependency to your package:

```swift
let package = Package(
	// ...
	dependencies: [
		.package(url: "https://github.com/Formkunft/swift-scoped-file-path", .upToNextMajor(from: "0.2.0")),
	],
	targets: [
		.target(
			// ...
			dependencies: [
				.product(name: "ScopedFilePath", package: "swift-scoped-file-path"),
			]),
	]
)
```

Then, import `ScopedFilePath` in your code:

```swift
import ScopedFilePath

// ...
```
