//
//  AlarmTrackerStateView.swift
//  i2app
//
//  Created by Arcus Team on 2/9/17.
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

class AlarmTrackerStateView: UIView {
  @IBOutlet var stateIcon: AlarmTrackerIconView!
  @IBOutlet var leftSegment: AlarmTrackerSegmentView!
  @IBOutlet var rightSegment: AlarmTrackerSegmentView!
  @IBOutlet var iconHeightConstraint: NSLayoutConstraint!
  @IBOutlet var iconWidthConstraint: NSLayoutConstraint!

  var activeColor: UIColor = UIColor.red {
    didSet {
      setNeedsDisplay()
    }
  }

  var inactiveColor: UIColor = UIColor.gray {
    didSet {
      setNeedsDisplay()
    }
  }

  var activeIconState: AlarmTrackerIconState = .activeIcon {
    didSet {
      setNeedsDisplay()
    }
  }

  var inactiveIconState: AlarmTrackerIconState = .inactiveIcon {
    didSet {
      setNeedsDisplay()
    }
  }

  var leftSegmentActiveType: SegmentType = .noSegment {
    didSet {
      setNeedsDisplay()
    }
  }

  var leftSegmentInactiveType: SegmentType = .noSegment {
    didSet {
      setNeedsDisplay()
    }
  }

  var rightSegmentActiveType: SegmentType = .noSegment {
    didSet {
      setNeedsDisplay()
    }
  }

  var rightSegmentInactiveType: SegmentType = .noSegment {
    didSet {
      setNeedsDisplay()
    }
  }

  var iconName: String? {
    didSet {
      setNeedsDisplay()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setNeedsDisplay()
  }

  override func setNeedsDisplay() {
    updateSubviews()
    super.setNeedsDisplay()
  }

  func updateSubviews() {
    updateLeftSegment()
    updateStateIcon()
    updateRightSegment()
  }

  func updateLeftSegment() {
    if leftSegment != nil {
      leftSegment.activeColor = activeColor
      leftSegment.inactiveColor = inactiveColor
      leftSegment.activeSegmentType = leftSegmentActiveType
      leftSegment.inactiveSegmentType = leftSegmentInactiveType
    }
  }

  func updateStateIcon() {
    if stateIcon != nil {
      if iconName != nil {
        stateIcon.icon = UIImage(named: iconName!)
      }
      stateIcon.activeColor = activeColor
      stateIcon.inactiveColor = inactiveColor
      stateIcon.activeIconState = activeIconState
      stateIcon.inactiveIconState = inactiveIconState
    }
  }

  func updateRightSegment() {
    if rightSegment != nil {
      rightSegment.activeColor = activeColor
      rightSegment.inactiveColor = inactiveColor
      rightSegment.activeSegmentType = rightSegmentActiveType
      rightSegment.inactiveSegmentType = rightSegmentInactiveType
    }
  }

  func performStateChange(_ ringWidth: CGFloat,
                          radius: CGFloat,
                          heightValue: CGFloat,
                          widthValue: CGFloat,
                          opacity: CGFloat) {
    iconHeightConstraint.constant = heightValue
    iconWidthConstraint.constant = widthValue
    stateIcon.radius = radius
    stateIcon.ringWidth = ringWidth
    stateIcon.foregroundLayer.opacity = Float(opacity)
    leftSegment.gradientLayer.opacity = Float(opacity)
    rightSegment.gradientLayer.opacity = Float(opacity)

    layoutIfNeeded()
  }
}
