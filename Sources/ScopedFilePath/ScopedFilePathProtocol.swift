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

public protocol ScopedFilePathProtocol: Hashable, CustomStringConvertible {
	typealias Component = FilePath.Component
	typealias CompareOptions = FilePathCompareOptions
	
	var storage: FilePath { get }
	
	init?(_ path: FilePath)
}

extension ScopedFilePathProtocol {
	public var components: FilePath.ComponentView { self.storage.components }
	public var lastComponent: FilePath.Component? { self.storage.lastComponent }
	public var description: String { self.storage.string }
	public var string: String { self.storage.string }
	public var stem: String? { self.storage.stem }
	public var `extension`: String? { self.storage.extension }
	
	public init?(platformString: [CInterop.PlatformChar]) {
		self.init(FilePath(platformString: platformString))
	}
	
	public init?(platformString: UnsafePointer<CInterop.PlatformChar>) {
		self.init(FilePath(platformString: platformString))
	}
	
	public init?(raw path: String) {
		self.init(FilePath(path))
	}
	
	public init?(precomposing path: String) {
		self.init(FilePath(path.precomposedStringWithCanonicalMapping))
	}
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.self.storage == rhs.self.storage
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.storage)
	}
	
	public var isEmpty: Bool {
		self.storage.isEmpty
	}
	
	public func appending(_ other: String) -> Self {
		Self(self.storage.appending(other))!
	}
	
	public func appending(_ other: FilePath.Component) -> Self {
		Self(self.storage.appending(other))!
	}
	
	public func appending(_ components: some Collection<FilePath.Component>) -> Self {
		Self(self.storage.appending(components))!
	}
	
	public func withExtension(_ `extension`: String?) -> Self {
		var valueCopy = self.storage
		
		valueCopy.extension = `extension`
		
		return Self(valueCopy)!
	}
	
	public func removingLastComponent() -> Self {
		Self(self.storage.removingLastComponent())!
	}
	
	public func starts(with prefix: Self, options: FilePathCompareOptions) -> Bool {
		if options.contains(.unicodeEquality) {
			self.storage.components.starts(with: prefix.components) { a, b in
				a.string == b.string
			}
		}
		else {
			self.storage.starts(with: prefix.self.storage)
		}
	}
}
