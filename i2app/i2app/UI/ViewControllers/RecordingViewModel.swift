//
//  RecordingViewModel.swift
//  i2app
//
//  Created by Arcus Team on 8/10/17.
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

struct RecordingViewModel {
  var recordingTime: Date {
    let timeStamp = recordingModel.getAttribute(kAttrRecordingTimestamp) as! Double
    let eventTime =  Date(timeIntervalSince1970: (timeStamp / 1000))
    return eventTime
  }

  var name: String {
    return RecordingCapability.getNameFrom(recordingModel)!
  }

  var time: String {
    return (recordingTime as NSDate).formatDateTimeStamp()
  }

  var durationString: String {
    return durationString( Int(RecordingCapability.getDurationFrom(recordingModel)) )
  }

  private func durationString(_ duration: Int) -> String {
    let seconds = duration % 60
    let minutes = (duration / 60) % 60
    let hours = duration / 3600

    if hours == 0 && minutes != 0 {
      return String(format:"%dm", minutes)
    } else if hours != 0 {
      return String(format:"%dh", hours)
    }
    return String(format:"%ds", seconds)
  }

  var sizeString: String {
    let recordingSize = Int64( RecordingCapability.getSizeFrom(recordingModel) )
    var size = "Unknown"
    if recordingSize > 0 {
      size = String(describing: ByteCountFormatter.string(fromByteCount: recordingSize, countStyle: .file))
    }
    return size
  }

  var recordingModel: RecordingModel
}

extension RecordingViewModel: Equatable {
  static func == (lhs: RecordingViewModel, rhs: RecordingViewModel) -> Bool {
    return lhs.recordingModel === rhs.recordingModel
  }
}
