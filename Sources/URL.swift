//
//  URL.swift
//  LightTableFilePaths
//
//  Copyright 2024 Florian Pircher
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if canImport(Foundation)

import Foundation

/// Assume that an absolute file path can always be converted to an URL.
/// Thus, the force unwrapping in the following initializers should never fail.
/// This is also why there are no `URL` initializers for `RelativeFilePath`.
public extension URL {
	@_disfavoredOverload
	init(_ filePath: AbsoluteFilePath) {
#if canImport(Darwin)
		if #available(macOS 13, *) {
			self.init(filePath: filePath.storage, directoryHint: .inferFromPath)!
		}
		else {
			self.init(filePath.storage)!
		}
#else
		self.init(fileURLWithPath: filePath.storage.string)
#endif
	}
	
	@available(macOS 13, *)
	init(_ filePath: AbsoluteFilePath, directoryHint: URL.DirectoryHint = .inferFromPath) {
		self.init(filePath: filePath.storage, directoryHint: directoryHint)!
	}
	
	init(_ filePath: AbsoluteFilePath, isDirectory: Bool) {
#if canImport(Darwin)
		if #available(macOS 13, *) {
			self.init(filePath: filePath.storage, directoryHint: isDirectory ? .isDirectory : .notDirectory)!
		}
		else {
			self.init(fileURLWithPath: filePath.storage.string, isDirectory: isDirectory)
		}
#else
		self.init(fileURLWithPath: filePath.storage.string, isDirectory: isDirectory)
#endif
	}
}

#endif
