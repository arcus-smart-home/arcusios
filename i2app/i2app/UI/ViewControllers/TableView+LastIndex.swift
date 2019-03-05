//
//  TableView+LastIndex.swift
//  i2app
//
//  Created by Arcus Team on 8/15/17.
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

extension UITableView {

  /// Returns true if the indexPath is the last index of the tableView with an offset applied
  /// If the offset is 5 will return true if the index is the fifth to the last cell in the tableview
  /// the offset is applied across sections
  func isLast(index indexPath: IndexPath, offset: Int = 0) -> Bool {
    var cellsFound = offset
    var sectionCellCount = 0
    var cursorSection = self.numberOfSections - 1
    guard cursorSection >= 0 else {
      return false
    }
    repeat {
      let cellCountForSection = numberOfRows(inSection: cursorSection)
      sectionCellCount = 0
      if cellsFound > 0 {
        sectionCellCount = cellCountForSection - cellsFound
      }

      if cellCountForSection > cellsFound {
        cellsFound -= cellsFound
      } else {
        cellsFound -= cellCountForSection
      }

      if cellsFound == 0 {
        continue
      } else {
        if cursorSection > 0 {
          cursorSection -= 1
        }
      }
    } while cellsFound > 0 && cursorSection >= 0
    return indexPath == IndexPath(indexes: [cursorSection, sectionCellCount])
  }
}
