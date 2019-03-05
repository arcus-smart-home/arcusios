//
//  PhoneNumberMasking.swift
//  i2app
//
//  Created by Arcus Team on 4/2/18.
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

/**
 `PhoneNumberMasking` protocol defines a mixin utility that can be used to add or remove '# (###) ###-####'
 formatting mask to a string representing a phone number.
 */
protocol PhoneNumberMasking {
  /**
   Utility used to remove the formatting mask from a phone number and will return the numeric string.

   - Parameters:
   - maskedString: String with phone number mask applied to it.

   - Returns: String of unmasked numeric values.
   */
  func stripPhoneMask(_ maskedString: String) -> String

  /**
   Utility used to apply the formatting mask to a numeric phone number string.

   - Parameters:
   - numericString: Numeric String to apply the formatting mask to.

   - Returns: String with phone number mask applied to it.
   */
  func applyPhoneMask(_ numericString: String) -> String
}

extension PhoneNumberMasking {
  func stripPhoneMask(_ maskedString: String) -> String {
    let string = maskedString as NSString
    let components = string.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
    let strippedString = components.joined(separator: "")

    return strippedString
  }

  func applyPhoneMask(_ numericString: String) -> String {
    var index = 0
    let formattedString = NSMutableString()
    let length = numericString.count

    var leadingOne: Bool = false
    if length > 1 {
      leadingOne = (numericString[numericString.startIndex] == "1")
    }

    // Format leading one if present.
    if leadingOne {
      formattedString.append("1 ")
      index += 1
    }

    // Format area code
    if (length - index) > 3 {
      let start = numericString.index(numericString.startIndex, offsetBy: index)
      let end = numericString.index(start, offsetBy: 3)
      let range = start..<end
      let areaCode = numericString.substring(with: range)
      formattedString.appendFormat("(%@) ", areaCode)
      index += 3
    }

    // Format local code
    if length - index > 3 {
      let start = numericString.index(numericString.startIndex, offsetBy: index)
      let end = numericString.index(start, offsetBy: 3)
      let range = start..<end
      let prefix = numericString.substring(with: range)

      formattedString.appendFormat("%@-", prefix)
      index += 3
    }

    // Format remaining number
    let start = numericString.index(numericString.startIndex, offsetBy: index)
    let remainder = numericString.substring(from: start)
    formattedString.append(remainder)

    return formattedString as String
  }
}
