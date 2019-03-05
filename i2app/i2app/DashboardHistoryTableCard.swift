//
//  DashboardHistoryTableViewCell.swift
//  i2app
//
//  Created by Arcus Team on 12/14/16.
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

class DashboardHistoryCard: DashboardServiceCard {
  @IBOutlet weak var emptyText: UILabel!

  @IBOutlet weak var timeOne: UILabel!
  @IBOutlet weak var deviceOne: UILabel!
  @IBOutlet weak var entryOne: UILabel!

  @IBOutlet weak var timeTwo: UILabel!
  @IBOutlet weak var deviceTwo: UILabel!
  @IBOutlet weak var entryTwo: UILabel!
  @IBOutlet weak var heightCollapseTwo: NSLayoutConstraint!

  @IBOutlet weak var timeThree: UILabel!
  @IBOutlet weak var deviceThree: UILabel!
  @IBOutlet weak var entryThree: UILabel!
  @IBOutlet weak var heightCollapseThree: NSLayoutConstraint!
}
