//
//  ArcusSegmentedControl.swift
//  i2app
//
//  Created by Arcus Team on 12/13/16.
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

let arcusKerningValue: Float = 2

@IBDesignable class ArcusSegmentedControl: UISegmentedControl {
  @IBInspectable var wideSpacing: Bool = false {
    didSet {
      updateSegmentLabels()
    }
  }

  @IBInspectable var allCaps: Bool = false {
    didSet {
      updateAllCaps()
    }
  }

  @IBInspectable var fontSize: Float = 12 {
    didSet {
      updateSegmentLabels()
    }
  }

  @IBInspectable var boldFont: Bool = false {
    didSet {
      updateSegmentLabels()
    }
  }

  @IBInspectable var segmentWidth: CGFloat = 100 {
    didSet {
      updateSegmentWidth(segmentWidth)
    }
  }

  @IBInspectable var textColor: UIColor = UIColor.black.withAlphaComponent(0.4) {
    didSet {
      updateSegmentLabels()
    }
  }

  @IBInspectable var selectedColor: UIColor = UIColor.white {
    didSet {
      updateSegmentLabels()
    }
  }

  // MARK: Initialization

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    configureSegmentedControl()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    configureSegmentedControl()
  }

  override init(items: [Any]?) {
    super.init(items: items)

    configureSegmentedControl()
  }

  // MARK: UI Configuration

  func configureSegmentedControl() {
    //Remove dividers
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
    let blank: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    //Remove border and highlighting for cells
    setDividerImage(blank,
                    forLeftSegmentState: UIControlState(),
                    rightSegmentState: UIControlState(),
                    barMetrics: .default)
    setBackgroundImage(blank,
                       for: UIControlState(),
                       barMetrics: .default)

    updateAllCaps()
  }

  func updateSegmentWidth(_ width: CGFloat) {
    for index in 0...(numberOfSegments-1) {
      setWidth(width, forSegmentAt: index)
    }
  }

  func updateSegmentLabels() {
    var kern: Float = 0
    if wideSpacing {
      kern = arcusKerningValue
    }
    let attributes: [AnyHashable : Any]? = FontData
      .getFontWithSize(fontSize,
                       bold: boldFont,
                       kerning: kern,
                       color: textColor)
    setTitleTextAttributes(attributes, for: UIControlState())

    let selectedAttributes: [AnyHashable : Any]? = FontData
      .getFontWithSize(fontSize,
                       bold: boldFont,
                       kerning: kern,
                       color: selectedColor)
    setTitleTextAttributes(selectedAttributes, for: .selected)

    setNeedsLayout()
  }

  func updateAllCaps() {
    guard numberOfSegments > 0 else {
      return
    }

    for index in 0...(numberOfSegments-1) {
      let title = titleForSegment(at: index)?.uppercased()
      setTitle(title, forSegmentAt: index)
    }
  }

  // MARK: UISegmentedControl Overriden Methods

  override func setTitle(_ title: String?, forSegmentAt segment: Int) {
    super.setTitle(title, forSegmentAt: segment)

    updateSegmentLabels()
  }

  override func insertSegment(with image: UIImage?, at segment: Int, animated: Bool) {
    super.insertSegment(with: image, at: segment, animated: animated)

    updateSegmentWidth(segmentWidth)
  }

  override func insertSegment(withTitle title: String?, at segment: Int, animated: Bool) {
    super.insertSegment(withTitle: title, at: segment, animated: animated)

    updateSegmentWidth(segmentWidth)
  }
}
