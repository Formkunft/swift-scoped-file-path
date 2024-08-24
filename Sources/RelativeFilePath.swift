//
//  RelativeFilePath.swift
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

import Foundation
#if canImport(System)
import System
#else
import SystemPackage
#endif

public struct RelativeFilePath: ExtendedFilePath, ExpressibleByStringLiteral, Sendable {
	public let storage: FilePath
	
	public init?(_ path: FilePath) {
		guard path.isRelative else {
			return nil
		}
		self.storage = path
	}
	
	public init(stringLiteral value: String) {
		self.init(FilePath(stringLiteral: value))!
	}
	
	public init?(relativeComponents stringComponents: some Sequence<String>) {
		var path = FilePath()
		
		for stringComponent in stringComponents {
			guard let component = FilePath.Component(stringComponent) else {
				return nil
			}
			path.append(component)
		}
		
		if let relativePath = RelativeFilePath(path) {
			self = relativePath
		}
		else {
			return nil
		}
	}
	
	public init(_ components: some Collection<FilePath.Component>) {
		self.init(FilePath(root: nil, components))!
	}
	
	public static func dropCommonPrefix(_ lhs: Self, _ rhs: Self) -> (base: Self, paths: (Self, Self)) {
		let lhsComponents = Array(lhs.storage.components)
		let rhsComponents = Array(rhs.storage.components)
		
		let firstUnequalElement = zip(lhsComponents, rhsComponents).enumerated().first { index, pair in
			return pair.0 != pair.1
		}
		
		if let firstUnequalElement {
			let base = Self(lhsComponents[lhsComponents.startIndex ..< firstUnequalElement.offset])
			let lhsResult = Self(lhsComponents[firstUnequalElement.offset...])
			let rhsResult = Self(rhsComponents[firstUnequalElement.offset...])
			return (base, (lhsResult, rhsResult))
		}
		else {
			return (Self(lhsComponents), ("", ""))
		}
	}
}
