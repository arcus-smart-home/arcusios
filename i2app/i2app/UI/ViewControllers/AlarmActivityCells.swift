//
//  AlarmActivityCells.swift
//  i2app
//
//  Created by Arcus Team on 1/18/17.
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

class AlarmActivityCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var moreIndicator: UIImageView!
  @IBOutlet weak var chevron: UIView!
}

extension AlarmActivityCell: ReuseableCell {
  class var reuseIdentifier: String {
    return "AlarmActivityCell"
  }
}

class AlarmNoActivityCell: UITableViewCell, ReuseableCell {
  class var reuseIdentifier: String {
    return "AlarmNoActivityCell"
  }
}
