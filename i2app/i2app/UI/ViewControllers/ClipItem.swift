//
//  ClipItem.swift
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
import PromiseKit
import SDWebImage

class ClipItem {

  var clipName: String
  var clipDuration: String
  var clipSize: String
  var clipTime: String
  var clipTrigger: String
  var isPinned: Bool = false
  var previewURL: URL?
  var clipPreviewImage: UIImage?
  var isRecording: Bool = false
  var recordingModel: RecordingModel
  var durationAndSizeString: String {
    if isRecording {
      return NSLocalizedString("In Progress", comment: "")
    } else {
      return "\(clipDuration), \(clipSize)"
    }
  }

  func fetchPreviewImage() {
    DispatchQueue.global(qos: .background).async {
      _ = RecordingCapability.view(on: self.recordingModel)
        .swiftThenInBackground({ (response) -> (PMKPromise?) in
          guard let res = response as? RecordingViewResponse,
            let preview = res.getPreview(),
            let previewURL = URL(string:preview) else {
              return nil
          }
          self.previewURL = previewURL
          self.section?.updated(clip: self)
          return nil
        })
    }
  }

  weak var section: ClipsSection?

  init(withRecordingModel: RecordingModel, inSection: ClipsSection) {
    self.recordingModel = withRecordingModel
    self.section = inSection
    self.clipName = ClipModelNameHelper.clipName(from: withRecordingModel)

    if let duration = withRecordingModel.durationString() {
      self.clipDuration = duration
    } else {
      self.clipDuration = ""
    }

    if let size = withRecordingModel.sizeString() {
      self.clipSize = size
    } else {
      self.clipSize = ""
    }

    if let time = withRecordingModel.time() {
      self.clipTime = time
    } else {
      self.clipTime = ""
    }



    self.clipTrigger = ""
    self.isRecording = (clipDuration == "0s" || clipSize == "Unknown")
    if let tags = Capability.tags(for: withRecordingModel) as? [String] {
      self.isPinned = tags.filter({$0 == kFavoriteTag}).count > 0
    } else {
      self.isPinned = false
    }
    self.fetchPreviewImage()
  }

}

extension ClipItem: Equatable {
  static func == (lhs: ClipItem, rhs: ClipItem) -> Bool {
    return
      lhs.recordingModel == rhs.recordingModel &&
        lhs.section == rhs.section
  }

  static func == (lhs: ClipItem, rhs: RecordingModel) -> Bool {
    return  lhs.recordingModel == rhs
  }
}
