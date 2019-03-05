//
//  AlarmRequirementsTableViewCells.swift
//  i2app
//
//  Created by Arcus Team on 1/10/17.
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

class AlarmRequirementsHeaderCell: UITableViewCell, ReuseableCell {

  class var reuseIdentifier: String {
    return "AlarmRequirementsHeaderCell"
  }
}

class AlarmRequirementsChangeCell: UITableViewCell, ReuseableCell {

  class var reuseIdentifier: String {
    return "AlarmRequirementsChangeCell"
  }

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var numberParticipatingLabel: UILabel!
  @IBOutlet weak var chevronView: UIView!
  @IBOutlet var leadingToTitleConstraint: NSLayoutConstraint!
  @IBOutlet var leadingToEdgeConstraint: NSLayoutConstraint!
}

class AlarmRequirementsFooterCell: UITableViewCell, ReuseableCell {

  class var reuseIdentifier: String {
    return "AlarmRequirementsFooterCell"
  }
}

class AlarmRequirementsNoSensorsCell: UITableViewCell {

  class var reuseIdentifier: String {
    return "AlarmRequirementsNoSensorsCell"
  }
}
