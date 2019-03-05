//
//  NotificationListCells.swift
//  i2app
//
//  Created by Arcus Team on 1/9/17.
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

class NotificationListHeaderTableViewCell: UITableViewCell, ReuseableCell {

  @IBOutlet var titleLabel: ArcusLabel!

  class var reuseIdentifier: String {
    return "NotificationListHeader"
  }
}

/// Cell to list that a user will be notified
class NotificationListNotifiedUserTableViewCell: UITableViewCell, HairlineConfigurable, ReuseableCell {

  @IBOutlet var selectionImage: UIImageView!
  @IBOutlet weak var detailImage: UIImageView!
  @IBOutlet var leadingToTitleConstraint: NSLayoutConstraint!
  @IBOutlet var leadingToEdgeConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: ArcusLabel!

  override func awakeFromNib() {
    selectionImage.translatesAutoresizingMaskIntoConstraints = false
    selectionImage.removeFromSuperview()
  }

  class var reuseIdentifier: String {
    return "NotificationListNotifiedUser"
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    if editing {
      if let v = self.subviews.filter({ String(describing: $0).range(of: "Reorder") != nil }).first,
        let i = v.subviews.filter({ $0 is UIImageView }).first as? UIImageView {
        i.image = UIImage(named: "ReorderTableCellImageWhite")
      }
      if let v = self.subviews.filter({ String(describing: $0).range(of: "Edit") != nil }).first,
        let subviews = v.subviews.filter({ $0 is UIImageView }) as? [UIImageView] {
        v.isUserInteractionEnabled = false
        subviews.forEach({ $0.isHidden = true })
        if selectionImage.superview != v {
          v.addSubview(selectionImage)
          let centerXConstraint = NSLayoutConstraint(item: selectionImage,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: v,
                                                     attribute: .centerX,
                                                     multiplier: 1,
                                                     constant: 0)
          let centerYConstraint = NSLayoutConstraint(item: selectionImage,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: v,
                                                     attribute: .centerY,
                                                     multiplier: 1,
                                                     constant: 0)
          v.addConstraints([centerXConstraint])
          v.addConstraints([centerYConstraint])
        }
        selectionImage.isHidden = false
      }
    }
  }
}

/// A footer Cell that direct the user how to add people to the Notification List
class NotificationListBasicFooterTableViewCell: UITableViewCell, ReuseableCell {
  class var reuseIdentifier: String {
      return "NotificationListBasicFooterTableViewCell"
  }
}

/// A footer Cell that direct the user how to add people to the Notification List
class NotificationListPremiumFooterTableViewCell: UITableViewCell, ReuseableCell {

  /// Chevron to display when the user is a Promon user
  @IBOutlet weak var chevronWhite: UIView!

  class var reuseIdentifier: String {
    return "NotificationListPremiumFooterTableViewCell"
  }
}

class AlarmNotificationListEditingFooterTableViewCell: ReuseableCell {

  class var reuseIdentifier: String {
    return "AlarmNotificationListEditingFooterTableViewCell"
  }
}

class AddMonitioringStationContactTableViewCell: UITableViewCell, ReuseableCell {

  class var reuseIdentifier: String {
    return "AddMonitioringStationContactTableViewCell"
  }
}
