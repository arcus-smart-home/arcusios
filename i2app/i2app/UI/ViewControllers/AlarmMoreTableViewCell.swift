//
//  AlarmMoreGenericTableViewCell.swift
//  i2app
//
//  Created by Arcus Team on 1/6/17.
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

/// A Cell for the AlarmMoreViewController's table view
class AlarmMoreGenericTableViewCell: UITableViewCell, ReuseableCell {

  /// ReuseableCell
  class var reuseIdentifier: String {
    return "AlarmMoreGenericTableViewCell"
  }

  /// Label on top that displays all caps text, setup for only one line of text
  @IBOutlet weak var titleLabel: UILabel!

  /// Label on bottom that gives more information about the content,
  /// is prepared to scale to more than one line of text
  @IBOutlet weak var subtitleLabel: UILabel!

  @IBOutlet weak var toggleSwitch: UISwitch!

  @IBOutlet weak var chevronView: UIView!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.selectionStyle = .none
  }
}

/// Alarm More's Discover Cell when the account cannot alarm
class AlarmMoreDiscoverCell: UITableViewCell, ReuseableCell {
  class var reuseIdentifier: String {
    return "AlarmMoreDiscoverCell"
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.selectionStyle = .none
  }

  @IBOutlet weak var discoverMoreButton: UIButton!
}
