//
//  CameraClipTableViewCell.swift
//  i2app
//
//  Created by Arcus Team on 8/14/17.
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
import RxSwift

protocol CameraClipTableViewCellDelegate: class {
  func playButtonPressed(onCell: CameraClipTableViewCell)
  func deleteButtonPressed(onCell: CameraClipTableViewCell)
  func downloadButtonPressed(onCell: CameraClipTableViewCell)
  func pinButtonPressed(onCell: CameraClipTableViewCell)
}

class CameraClipTableViewCell: UITableViewCell, ReuseableCell {
  weak var delegate: CameraClipTableViewCellDelegate?
  @IBOutlet weak var videoImage: UIImageView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var pinButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var downloadButton: UIButton!
  @IBOutlet weak var videoExpirationLabel: ArcusLabel!
  @IBOutlet weak var videoMetaDataLabel: ArcusLabel!
  @IBOutlet weak var videoCameraName: ArcusLabel!
  @IBOutlet weak var videoCameraNameLabelTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var previewUnavailableLabel: ArcusLabel!
  
  @IBAction func playButtonPressed(_ sender: UIButton) {
    self.delegate?.playButtonPressed(onCell: self)
  }

  @IBAction func deleteButtonPressed(_ sender: UIButton) {
    self.delegate?.deleteButtonPressed(onCell: self)
  }

  @IBAction func downloadButtonPressed(_ sender: UIButton) {
    self.delegate?.downloadButtonPressed(onCell: self)
  }

  @IBAction func pinButtonPressed(_ sender: UIButton) {
    self.delegate?.pinButtonPressed(onCell: self)
  }
  
  // Calculate the remaining time of a video before expiration
  func getVideoExpirationTimeString(withEndDate endDate: Date?) -> String? {
    if let end = endDate {
      let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: end)
      
      guard let day = components.day,
        let hour = components.hour,
        let minute = components.minute,
      let seconds = components.second else { return nil }
      
      var status = ""
      
      if day > 2 {
        status = "Expires in \(day) days"
      } else if day >= 1 && day < 2 {
        status = "Expires in \(day) day, \(hour) hr"
      } else if day < 1 && hour > 0{
        status = "Expires in \(hour) hr, \(minute) min"
      } else if day < 1 && hour < 1 && minute > 0 {
        status = "Expires in \(minute) min"
      } else if seconds < 1 {
        status = "Expired"
      }
      
      return status
    } else {
      return nil
    }
  }
}
