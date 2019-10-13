//
//  ContactSupportHandler.swift
//  i2app
//
//  Created by Arcus Team on 3/3/17.
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

let kTelPromtCustomerService = "telprompt:+18554694747"
let kTelPromtMonitoringService = "telprompt:+18445716006"
let kCustomerServiceNumber = "1-0"
let kMonitoringServiceNumber = "1-0"

protocol ContactSupportHandler {
  // MARK: Extended
  func contactCustomerSupport()
  func contactMonitoringSupport()

  func customerSupportNumber() -> String
  func monitoringSupportNumber() -> String
}

extension ContactSupportHandler {
  func contactCustomerSupport() {
    performTelPrompt(kTelPromtCustomerService)
  }

  func contactMonitoringSupport() {
    performTelPrompt(kTelPromtMonitoringService)
  }

  func customerSupportNumber() -> String {
    return kCustomerServiceNumber
  }

  func monitoringSupportNumber() -> String {
    return kMonitoringServiceNumber
  }

  fileprivate func performTelPrompt(_ prompt: String) {
    if let promptUrl = URL(string: prompt) {
      if UIApplication.shared.canOpenURL(promptUrl) {
        UIApplication.shared.open(promptUrl)
      }
    }
  }
}
