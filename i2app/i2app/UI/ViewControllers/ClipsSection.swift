//
//  ClipsSection.swift
//  i2app
//
//  Created by Arcus Team on 8/16/17.
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

class ClipsSection {
  var title = ""
  var items: [ClipItem]
  var date: Date
  weak var owner: CameraClipsPresenterProtocol?

  init(withTitle: String = "", date: Date, owner: CameraClipsPresenterProtocol) {
    title = withTitle
    items = []
    self.date = date
    self.owner = owner
  }

  func addRecord(_ record: RecordingModel) {
    let clipItem = ClipItem(withRecordingModel: record, inSection: self)
    items.append(clipItem)
    items.sort { (clip1, clip2) -> Bool in
      if let date1 = clip1.recordingModel.recordingTime() as Date?,
        let date2 = clip2.recordingModel.recordingTime() as Date? {
        return date1 > date2
      }
      return false
    }
  }

  func updated(clip: ClipItem) {
    if let idx = items.index(of: clip) {
      owner?.updated(section: self, clipIndex: idx)
    }
  }
}

extension ClipsSection: Equatable {
  static func == (lhs: ClipsSection, rhs: ClipsSection) -> Bool {
    return lhs.title == rhs.title && lhs.date == rhs.date
  }
}
