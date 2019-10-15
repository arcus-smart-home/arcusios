//
//  RecordingModel+Extension.swift
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

extension RecordingModel {
  override public var name: String {
    guard let name = RecordingCapabilityLegacy.getName(self) else {
      return ""
    }
    return name
  }

  func recordingTime() -> NSDate? {
    guard let timestamp = self.getAttribute(kAttrRecordingTimestamp) as? Double else {
      return nil
    }
    return Date(milliseconds: timestamp) as NSDate
  }
  
  func recordDateAndDuration() -> String? {
    if let recordDate = recordingTime()?.formatDate("MM/dd/yy h:mma"),
      let durationString = self.durationString() {
      return String(format: "%@ %@", arguments: [recordDate, durationString])
    }
    return nil
  }

  func time() -> String? {
    return recordingTime()?.formatDateTimeStamp()
  }
  
  func cameraID() -> String? {
    return RecordingCapability.getCameraidFrom(self)
  }

  func durationString() -> String? {
    return RecordingModel.durationString(Int(RecordingCapability.getDurationFrom(self)))
  }
  
  func deleteTime() -> Date? {
    return RecordingCapability.getDeleteTime(from: self)
  }
  
  func isVideoExpired() -> Bool {
    if let end = self.deleteTime() {
      let components = Calendar.current.dateComponents([.second], from: Date(), to: end)
      
      guard let seconds = components.second else { return false }
      
      if seconds < 0 {
        return true
      } else {
        return false
      }
    }
    return false
  }

  func sizeString() -> String? {
    var size = "Unknown"

    let recordingSize = RecordingCapability.getSizeFrom(self)

    if recordingSize > 0 {
      let formatter = ByteCountFormatter()
      formatter.countStyle = .binary

      size = formatter.string(fromByteCount: Int64(recordingSize))
    }
    return size
  }

  func length() -> String? {
    return nil
  }

  static func durationString(_ duration: Int) -> String? {
    let seconds: Int = duration % 60
    let minutes: Int  = (duration / 60) % 60
    let hours: Int = duration / 3600

    if hours == 0 && minutes != 0 {
      return "\(minutes)m \(seconds)s"
    } else if hours != 0 {
      return "\(hours)h"
    } else {
      return "\(seconds)s"
    }
  }
}
