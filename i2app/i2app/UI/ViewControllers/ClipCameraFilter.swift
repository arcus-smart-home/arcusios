//
//  ClipCameraFilter.swift
//  i2app
//
//  Created by Arcus Team on 8/18/17.
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

struct ClipCameraFilter {

  /// Camera to use or all if nil
  var address: String?
  var name: String
  init(address: String?, name: String ){
    self.address = address
    self.name = name
  }
  
  private static let allDevicesName = NSLocalizedString("All Devices", comment: "")
  static let defaultFilter = ClipCameraFilter(address: nil,
                                              name: ClipCameraFilter.allDevicesName)
}

extension ClipCameraFilter: Equatable {
  public static func ==(lhs: ClipCameraFilter, rhs: ClipCameraFilter) -> Bool {
    //consider the address for cameras that are named the same
    var addressTheSame = true
    if let lhsadd = lhs.address,
      let rhsadd = rhs.address {
      addressTheSame = lhsadd == rhsadd
    }
    // compare the name and address for "All Devices" vs other Cameras, may not work as expected 
    // if your camera is named "All Devices"
    return lhs.name == rhs.name && addressTheSame
  }
}
