//
//  HairlineConfigurable.swift
//  i2app
//
//  Created by Arcus Team on 1/25/17.
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

enum HairlineRule {
  case title
  case edge
}

protocol HairlineConfigurable {
  var leadingToTitleConstraint: NSLayoutConstraint! { get }
  var leadingToEdgeConstraint: NSLayoutConstraint! { get }
  func setToTitle()
  func setToEdge()
}

extension HairlineConfigurable where Self : UITableViewCell {

  func setToTitle() {
    self.leadingToEdgeConstraint.isActive = false
    self.leadingToTitleConstraint.isActive = true
  }

  func setToEdge() {
    self.leadingToEdgeConstraint.isActive = true
    self.leadingToTitleConstraint.isActive = false
  }
}

extension UITableView {

  func isLastCellInSection(_ indexPath: IndexPath) -> Bool {
    guard let dataSource = self.dataSource else {
      return false
    }
    let rowMax = dataSource.tableView(self, numberOfRowsInSection: indexPath.section)
    return indexPath.row == rowMax - 1
  }

  func configureCellHairline(_ cell: HairlineConfigurable, withIndexPath indexPath: IndexPath) {
    if self.isLastCellInSection(indexPath) || self.isEditing {
      cell.setToEdge()
    } else {
      cell.setToTitle()
    }
  }

}
