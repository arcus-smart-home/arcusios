//
//  String+Util.swift
//  i2app
//
//  Created by Arcus Team on 9/26/17.
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

extension String {
  func removingWhitespaces() -> String {
    return components(separatedBy: .whitespaces).joined()
  }

  /**
   Convert hexadecimal `String` to `NSData`

   - Returns: `NSData` representation of the current String.
   */
  func dataFromHexString() -> NSData? {
    // Convert 0 ... 9, a ... f, A ...F to their decimal value,
    // return nil for all other input characters
    func decodeNibble(u: UInt16) -> UInt8? {
      switch(u) {
      case 0x30 ... 0x39:
        return UInt8(u - 0x30)
      case 0x41 ... 0x46:
        return UInt8(u - 0x41 + 10)
      case 0x61 ... 0x66:
        return UInt8(u - 0x61 + 10)
      default:
        return nil
      }
    }

    guard let data = NSMutableData(capacity: utf16.count/2) else {
      return nil
    }

    var i = utf16.startIndex
    while i != utf16.endIndex {
      guard let hi = decodeNibble(u: utf16[i]),
        let lo = decodeNibble(u: utf16[utf16.index(i, offsetBy: 1, limitedBy: utf16.endIndex)!]) else {
          return nil
      }
      var value = hi << 4 + lo
      data.append(&value, length: 1)
      i = utf16.index(i, offsetBy: 2, limitedBy: utf16.endIndex)!
    }
    return data
  }
}
