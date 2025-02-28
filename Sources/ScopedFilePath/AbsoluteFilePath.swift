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

import Foundation
#if canImport(System)
import System
#else
import SystemPackage
#endif

public struct AbsoluteFilePath: ScopedFilePathProtocol, Sendable {
	public let storage: FilePath
	
	public init?(_ path: FilePath) {
		guard path.isAbsolute else {
			return nil
		}
		self.storage = path
	}
	
	public init?(raw url: URL) {
		self.init(FilePath(url.path))
	}
	
	public init?(precomposing url: URL) {
		self.init(FilePath(url.path.precomposedStringWithCanonicalMapping))
	}
	
	public func appending(_ path: RelativeFilePath) -> AbsoluteFilePath {
		AbsoluteFilePath(storage.pushing(path.storage))!
	}
	
	public func removingPrefix(_ prefix: AbsoluteFilePath, options: FilePathCompareOptions) -> RelativeFilePath? {
		guard storage.components.count >= prefix.storage.components.count else {
			return nil
		}
		
		var clipIndex = storage.components.startIndex
		
		for (c0, c1) in zip(storage.components, prefix.storage.components) {
			guard options.contains(.unicodeEquality) ? c0.string == c1.string : c0 == c1 else {
				return nil
			}
			clipIndex = storage.components.index(after: clipIndex)
		}
		
		return RelativeFilePath(storage.components[clipIndex...])
	}
}
