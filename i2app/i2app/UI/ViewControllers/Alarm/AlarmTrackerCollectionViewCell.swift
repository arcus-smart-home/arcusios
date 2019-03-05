//
//  AlarmTrackerCollectionViewCell.swift
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

private let kDefaultMaxRingScale: CGFloat = 1.0
private let kDefaultsMinRingScale: CGFloat = 0.6
private let kDefaultMaxIconHeight: CGFloat = 125.0
private let kDefaultMinIconHeight: CGFloat = 75.0
private let kDefaultMaxIconWidth: CGFloat = 100.0
private let kDefaultMinIconWidth: CGFloat = 60.0
private let kDefaultMaxIconRadius: CGFloat = 46.0
private let kDefaultMinIconRadius: CGFloat = 27.5
private let kDefaultMaxRingWidth: CGFloat = 10.0
private let kDefaultMinRingWidth: CGFloat = 5.0

@IBDesignable class AlarmTrackerCollectionViewCell: UICollectionViewCell {
  @IBOutlet var stateView: AlarmTrackerStateView!
  @IBOutlet var stateLabel: ArcusLabel!

  @IBInspectable var maxRingScale: CGFloat = kDefaultMaxRingScale {
    didSet {

    }
  }
  @IBInspectable var minRingScale: CGFloat = kDefaultMaxRingScale {
    didSet {

    }
  }

  @IBInspectable var maxIconHeight: CGFloat = kDefaultMaxIconHeight {
    didSet {

    }
  }

  @IBInspectable var minIconHeight: CGFloat = kDefaultMinIconHeight {
    didSet {

    }
  }

  @IBInspectable var maxIconWidth: CGFloat = kDefaultMaxIconWidth {
    didSet {

    }
  }

  @IBInspectable var minIconWidth: CGFloat = kDefaultMinIconWidth {
    didSet {

    }
  }

  @IBInspectable var maxIconRadius: CGFloat = kDefaultMaxIconRadius {
    didSet {

    }
  }

  @IBInspectable var minIconRadius: CGFloat = kDefaultMinIconRadius {
    didSet {

    }
  }

  @IBInspectable var maxRingWidth: CGFloat = kDefaultMaxRingWidth {
    didSet {

    }
  }

  @IBInspectable var minRingWidth: CGFloat = kDefaultMinRingWidth {
    didSet {

    }
  }

  var opacity: CGFloat = 0.0

  func updateTransitionState(_ percent: CGFloat) {
    stateView.alpha = stateViewAlpha(percent)
    stateLabel.alpha = percent
    stateView.performStateChange(ringWidthValue(percent),
                                 radius: ringRadiusValue(percent),
                                 heightValue: iconViewHeight(percent),
                                 widthValue:  iconViewWidth(percent),
                                 opacity: percent)

    self.layoutIfNeeded()
  }

  // MARK: Private Methods

  fileprivate func ringWidthValue(_ percent: CGFloat) -> CGFloat {
    return scaledValue(minRingWidth,
                       maxValue: maxRingWidth,
                       percent: percent)
  }

  fileprivate func ringRadiusValue(_ percent: CGFloat) -> CGFloat {
    return scaledValue(minIconRadius,
                       maxValue: maxIconRadius,
                       percent: percent)
  }

  fileprivate func ringScaleValue(_ percent: CGFloat) -> CGFloat {
    return scaledValue(minRingScale,
                       maxValue: maxRingScale,
                       percent: percent)
  }

  fileprivate func iconViewHeight(_ percent: CGFloat) -> CGFloat {
    return scaledValue(minIconHeight,
                       maxValue: maxIconHeight,
                       percent: percent)
  }

  fileprivate func iconViewWidth(_ percent: CGFloat) -> CGFloat {
    return scaledValue(minIconWidth,
                       maxValue: maxIconWidth,
                       percent: percent)
  }

  fileprivate func scaledValue(_ minValue: CGFloat,
                               maxValue: CGFloat,
                               percent: CGFloat) -> CGFloat {
    let difference = maxValue - minValue
    let scaleValue: CGFloat = minValue + (difference * percent)
    if scaleValue > maxValue {
      return maxValue
    } else if scaleValue < minValue {
      return minValue
    }

    return scaleValue
  }

  fileprivate func stateViewAlpha(_ percent: CGFloat) -> CGFloat {
    if opacity < percent {
      opacity = percent
    }
    return opacity
  }
}
