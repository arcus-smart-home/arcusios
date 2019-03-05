//
//  CameraVideoStorageViewModel.swift
//  i2app
//
//  Created by Arcus Team on 8/23/17.
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

/**
`CameraVideoStorageViewModel` protocol
 */
protocol CameraVideoStorageViewModel {
  var capacity: Double { get set }
  var usage: Double { get set }

  /**
   Get the percent value of the current usuage of video storage.

   - Returns: `CGFloat` representing usuage / quota.
   */
  func percentValue() -> CGFloat

  /**
   Get the percent string of the current usuage of video storage.

   - Returns: `String` representing usuage / quota.
   */
  func usePercentage() -> String

  /**
   Get the descriptin of the current usuage of video storage.

   - Returns: `String` representing "<usuage> gb of <capacity> gb used"
   */
  func useDescription() -> String
}

/**
 `CameraStorageViewModel` struct that conforms to `CameraVideoStorageViewModel`
 */
struct CameraStorageViewModel: CameraVideoStorageViewModel {
  var capacity: Double
  var usage: Double

  init(capacity: Double, usage: Double) {
    self.capacity = capacity
    self.usage = usage
  }

  func percentValue() -> CGFloat {
    guard capacity > 0 else {
      return 0.0
    }
    return CGFloat(usage / capacity)
  }

  func usePercentage() -> String {
    var percent = Int(ceil(percentValue() * 100))
    if percent > 100 {
      percent = 100
    }
    return String(describing: percent)
  }

  func useDescription() -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = .useGB
    formatter.countStyle = .binary
    let usageCount = quotaSizeString(usage)
    let capacityCount = quotaSizeString(capacity)

    return "\(usageCount) of \(capacityCount) used"
  }
  
  /*
   * Converts a byte count into a GB-relative, human readable format following the specifications
   * provided by Robbie Falls. This is not a "normal" conversion and intentionally produces
   * mathematically incorrect results.
   *
   * 0 returns "0 GB", all other values are converted to GB (using 1024 per K) and displayed
   * with one optional decimal place that is always rounded up. Thus, an input of 1 (byte) returns
   * "0.1 GB" but 1073741824 returns "1 GB"
   */
  func quotaSizeString(_ bytes: Double) -> String {
    let bytesPerGb = 1024.0 /*kb*/ * 1024.0 /*mb*/ * 1024.0
    
    if bytes == 0 {
      return "0 GB"
    } else if bytes <= (bytesPerGb * 0.1) {
      return "0.1 GB"
    }
    
    let gbs = bytes / bytesPerGb

    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 1
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1

    var qSize = " GB"
    if let quota = formatter.string(from: NSNumber(value: gbs)) {
      qSize = quota + " GB"
    }

    return qSize
  }
}
