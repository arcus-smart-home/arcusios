//
//  ArcusNameSorter.swift
//  i2app
//
//  Created by Arcus Team on 5/8/17.
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
import Cornea

public final class ArcusNameSorter: NSObject {

  /// sortedDevices safely sorts an aray of DeviceProductCatalog objects using a case Insensitive Comparison
  /// However 1st Gen devices show up at the end of the list
  public static func sortedArcusDevices(_ devices: [AnyObject]) -> [AnyObject] {

    guard let dicts = devices as? [DeviceProductCatalog] else {
      return devices
    }

    let returnValue = dicts.sorted { lhs, rhs -> Bool in

      if lhs.productName.contains("1st Gen") &&
        rhs.productName.contains("1st Gen") {
        return lhs.productName.caseInsensitiveCompare(rhs.productName) == .orderedAscending
      } else if lhs.productName.contains("1st Gen") &&
        !rhs.productName.contains("1st Gen") {
        return false
      } else if rhs.productName.contains("1st Gen") &&
        !lhs.productName.contains("1st Gen") {
        return true
      }
      return lhs.productName.caseInsensitiveCompare(rhs.productName) == .orderedAscending
    }

    return returnValue as [AnyObject]
  }

  /// sortedDevices safely sorts an aray of DeviceProductCatalog objects using a case Insensitive Comparison
  public static func sortedDevices(_ devices: [AnyObject]) -> [AnyObject] {
    guard let dicts = devices as? [DeviceProductCatalog] else {
      return devices
    }
    let returnValue = dicts.sorted { lhs, rhs -> Bool in
      return lhs.productName.caseInsensitiveCompare(rhs.productName) == .orderedAscending
    }
    return returnValue as [AnyObject]
  }
}
