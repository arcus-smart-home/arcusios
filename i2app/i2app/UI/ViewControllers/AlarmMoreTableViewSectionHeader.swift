//
//  AlarmMoreTableViewSectionHeader.swift
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

/// A custom tableview Section Header for the Alarm More View Controller
class AlarmMoreTableViewSectionHeader: ArcusTwoLabelTableViewSectionHeader, ReuseableCell {

  /// Displays one line of text
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconImageView1: UIImageView!
  @IBOutlet weak var iconImageView2: UIImageView!
  @IBOutlet weak var iconImageView3: UIImageView!
  @IBOutlet weak var iconImageView4: UIImageView!
  @IBOutlet weak var iconImageView5: UIImageView!

  /**
   Takes in a list of images and sets them in order **right to left** on the right hand side of the view

   * maximum of 4 images
   * extra UIImageViews are hidden
   * resets images if reused

   This is a cocoa caveman's cheap stack view
   */
  func setImages(_ images: [UIImage]) {
    let imageViews = [iconImageView1, iconImageView2, iconImageView3, iconImageView4, iconImageView5]
    imageViews.forEach { v in
      v?.isHidden = true
    }
    // Note to future programmer, Swift 2.3 doesn't have iterators yet when I wrote this
    var i = images.startIndex
    images.reversed().forEach { image in
      let imageView = imageViews[i]
      imageView?.image = image
      imageView?.isHidden = false
      i += 1
    }
  }

  class var reuseIdentifier: String {
    return "AlarmMoreTableViewSectionHeader"
  }

  class var nib: UINib {
    return UINib(nibName: "AlarmMoreTableViewSectionHeader", bundle: Bundle.main)
  }
}
