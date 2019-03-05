//
//  HubIDTextFieldDelegateProtocol.swift
//  i2app
//
//  Created by Arcus Team on 6/22/17.
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

import UIKit

/// Shared logic for handling a text field for Hub Id input
internal protocol EnhancedHubIDTextFieldDelegateProtocol: class, UITextFieldDelegate {

  /// handle string replacement to add a `-` at the 4th index
  /// Can't just extend the UITextFieldDelegate method because it must be taged with `@objc`
  ///
  /// extended
  func hubIdTextField(_ textField: UITextField,
                      shouldChangeCharactersIn range: NSRange,
                      replacementString string: String) -> Bool
}

extension EnhancedHubIDTextFieldDelegateProtocol {

  func hubIdTextField(_ textField: UITextField,
                      shouldChangeCharactersIn range: NSRange,
                      replacementString string: String) -> Bool { // return NO to not change text

    textField.textColor = UIColor.black
    // if first character or deletion just continue
    guard let textFieldText = textField.text,
      string != "" else {
        return true
    }

    guard range.length == 0, string.count == 1 else {
      // case for copy paste, just go ¯\_(ツ)_/¯
      return true
    }

    //calculate new length
    let moddedLength = textFieldText.count - (range.length - string.count)

    // max size.
    if moddedLength >= 9 {
      return false
    }

    // Auto-add hyphen before appending 4rd character if hyphen is not enetered by user
    if moddedLength == 4, string != "-" {
      textField.text = format(hubString: textFieldText, checkString: string)
      return false
    }
    return true
  }

  // helper function
  func format(hubString originalHubString: String, checkString check: String) -> String {
    let location = 3
    let index = originalHubString.index(originalHubString.startIndex, offsetBy: 3)
    var newHubString = originalHubString
    if newHubString.count == location {
      newHubString.insert("-", at: index)
      newHubString += check
    }
    return newHubString
  }
}
