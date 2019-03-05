//
//  RuleModel+Extension.swift
//  i2app
//
//  Created by Arcus Team on 9/29/17.
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

extension RuleModel {
  func getDeviceAddress() -> String? {
    if let context = RuleCapability.getContextFrom(self) as? [AnyHashable: AnyObject] {
      for (_, value) in context {
        if let valueString = value as? String {
          if valueString.hasPrefix("DRIV:dev:") {
            return valueString
          }
        }
      }
    }
    return nil
  }

  func getDeviceId() -> String? {
    if let address = getDeviceAddress() {
      return (address as NSString).substring(to: 9)
    }
    return nil
  }

  func getTemplateId() -> String? {
    return RuleCapability.getTemplateFrom(self)
  }

  func getCreatedDate() -> Date? {
    return RuleCapability.getCreatedFrom(self)
  }
}
