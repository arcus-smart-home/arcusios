//
//  SuperToCells.swift
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

import UIKit

extension UIView {

  var superTableViewCell: UITableViewCell? {
    var superCell: UIView? = self as UIView
    while superCell != nil &&
      !superCell!.isKind(of: UITableViewCell.self) {
        if superCell!.superview != nil {
          superCell = superCell!.superview!
        } else {
          superCell = nil
        }
    }
    if superCell != nil && superCell!.isKind(of: UITableViewCell.self) {
      return (superCell as? UITableViewCell)
    }
    return nil
  }

  var superCollectionViewCell: UICollectionViewCell? {
    var superCell: UIView? = self as UIView
    while superCell != nil &&
      !superCell!.isKind(of: UICollectionViewCell.self) {
        if superCell!.superview != nil {
          superCell = superCell!.superview!
        } else {
          superCell = nil
        }
    }
    if superCell != nil && superCell!.isKind(of: UICollectionViewCell.self) {
      return (superCell as? UICollectionViewCell)
    }
    return nil
  }
}
