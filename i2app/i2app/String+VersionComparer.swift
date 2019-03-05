//
//  String+VersionComparer.swift
//  i2app
//
//  Created by Arcus Team on 8/31/18.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

import Foundation

// https://github.com/DragonCherry/VersionCompare
// This is published under the Unlicense 
extension String {

  /// Inner comparison utility to handle same versions with different length. (Ex: "1.0.0" & "1.0")
  private func compare(toVersion targetVersion: String) -> ComparisonResult {

    let versionDelimiter = "."
    var result: ComparisonResult = .orderedSame
    var versionComponents = components(separatedBy: versionDelimiter)
    var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
    let spareCount = versionComponents.count - targetComponents.count

    if spareCount == 0 {
      result = compare(targetVersion, options: .numeric)
    } else {
      let spareZeros = repeatElement("0", count: abs(spareCount))
      if spareCount > 0 {
        targetComponents.append(contentsOf: spareZeros)
      } else {
        versionComponents.append(contentsOf: spareZeros)
      }
      result = versionComponents.joined(separator: versionDelimiter)
        .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
    }
    return result
  }

  public func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
  public func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
  public func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
  public func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
  public func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }
}
