//
//  ColorTemperatureLabelsView.swift
//  i2app
//
//  Created by Arcus Team on 6/27/16.
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

import UIKit
import Cornea

@objc class ColorTemperatureLabelsView: UIView {
  @IBOutlet var titleLabel: ArcusLabel!
  @IBOutlet var valueLabel: ArcusLabel!
  @IBOutlet var divider: UIView!

  func updateTemperateLabel(_ temperatureValue: Int) {
    if let temperatureString = self.temperatureTitleString(temperatureValue) {
      self.titleLabel.text = temperatureString
    }
    self.valueLabel.attributedText = self.temperatureValueString(temperatureValue)
  }

  func temperatureTitleString(_ temperatureValue: Int) -> String? {
    var string: String?

    if temperatureValue < 2700 {
      string = NSLocalizedString("Warm", comment: "")
    } else if temperatureValue <= 3000 {
      string = NSLocalizedString("Warm White", comment: "")
    } else if temperatureValue <= 3500 {
      string = NSLocalizedString("Neutral", comment: "")
    } else if temperatureValue <= 4700 {
      string = NSLocalizedString("Cool White", comment: "")
    } else if temperatureValue <= 6500 {
      string = NSLocalizedString("Day Light", comment: "")
    } else {
      string = NSLocalizedString("More Blue Sky", comment: "")
    }

    return string
  }

  func temperatureValueString(_ temperatureValue: Int) -> NSAttributedString? {
    let ssFont: UIFont = self.valueLabel.font.withSize(8)

    let attributedString: NSMutableAttributedString =
      NSMutableAttributedString(string: "\(temperatureValue)K",
        attributes: [NSFontAttributeName: self.valueLabel.font])
    attributedString
      .setAttributes([NSFontAttributeName: ssFont,
                      NSBaselineOffsetAttributeName: 5,
                      NSForegroundColorAttributeName: self.valueLabel.textColor.withAlphaComponent(0.6)],
                     range: NSRange(location:attributedString.length - 1,
                                    length:1))

    return attributedString
  }
}
