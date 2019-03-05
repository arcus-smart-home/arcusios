//
//  LiveCameraTableViewCell.swift
//  i2app
//
//  Created by Arcus Team on 8/8/17.
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

@objc protocol LiveCameraDeviceCellDelegate: class {
  func recordButtonPressed(onCell: UITableViewCell)
  func playButtonPressed(onCell: UITableViewCell)
}

class LiveCameraTableViewCell: UITableViewCell, ReuseableCell {

  static var reuseIdentifier: String {
    return String(describing: self)
  }

  weak var delegate: LiveCameraDeviceCellDelegate?
  @IBOutlet weak var videoImage: UIImageView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var deviceNameLabel: ArcusLabel!
  @IBOutlet weak var eventValueLabel: ArcusLabel!
  @IBOutlet weak var cameraIcon: UIImageView!
  @IBOutlet weak var previewUnavailableLabel: ArcusLabel!
  @IBOutlet weak var recordButtonContainer: UIView?
  
  @IBAction func recordButtonPressed(_ sender: UIButton) {
    self.delegate?.recordButtonPressed(onCell: self)
  }

  @IBAction func playButtonPressed(_ sender: UIButton) {
    self.delegate?.playButtonPressed(onCell: self)
  }
}
