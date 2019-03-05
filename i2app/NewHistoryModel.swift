//
//  NewHistoryModel.swift
//  i2app
//
//  Created by Arcus Team on 2/17/17.
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

@objc
class NewHistoryModel: NSObject {

  /* Example Model
   "timestamp": 1487344820748,
   "key": "incident.triggered",
   "subjectAddress": "SERV:incident:8d2e5330-f524-11e6-8bc4-45876a432d52",
   "subjectName": "Security Alarm",
   "shortMessage": "Triggered",
   "longMessage": "Triggered"
   */
  var timestamp: NSNumber = 0
  var date: Date {
    let eventTime = Date(timeIntervalSince1970: timestamp.doubleValue / 1000.0 )
    return eventTime

  }
  var key: String = ""
  var subjectAddress: String = ""
  var subjectName: String = ""
  var shortMessage: String = ""
  var longMessage: String = ""

  required init?(dictionary: [AnyHashable: Any]) {
    if let timestamp = dictionary["timestamp"] as? NSNumber {
      self.timestamp = timestamp
    }
    if let key = dictionary["key"] as? String {
      self.key = key
    }
    if let subjectAddress = dictionary["subjectAddress"] as? String {
      self.subjectAddress = subjectAddress
    }
    if let subjectName = dictionary["subjectName"] as? String {
      self.subjectName = subjectName
    }
    if let shortMessage = dictionary["shortMessage"] as? String {
      self.shortMessage = shortMessage
    }
    if let longMessage = dictionary["longMessage"] as? String {
      self.longMessage = longMessage
    }
  }

  func isIncident() -> Bool {
    return self.subjectAddress.contains("SERV:incident")
  }
}
