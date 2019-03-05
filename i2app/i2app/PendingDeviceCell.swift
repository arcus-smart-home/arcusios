//
//  PendingDeviceCell.swift
//  i2app
//
//  Arcus Team on 3/21/18.
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

class PendingDeviceCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var deviceIcon: UIImageView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  func bindToModel(_ model: PendingDeviceSectionModel) {
    titleLabel.text = model.deviceName
    subtitleLabel.text = model.disposition
  }
  
  /// Required to keep spinner spinning after cell has been recycled.
  /// See: https://stackoverflow.com/questions/28737772/uiactivityindicatorview-stops-animating-in-uitableviewcell
  override func prepareForReuse() {
    super.prepareForReuse()
    if let spinner = self.spinner {
      spinner.startAnimating()
    }
  }
}
