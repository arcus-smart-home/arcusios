//
//  AlarmTrackerSegmentView.swift
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
import AVFoundation

enum SegmentType {
  case noSegment
  case inactive
  case inactiveActive
  case activeInactive
  case activeNone
  case inactiveNone
}

enum SegmentSide {
  case left
  case right
}

private let kDefaultLineWidth: CGFloat = 5.0
private let kDefaultActiveColor: UIColor = UIColor.red
private let kDefaultInactiveColor: UIColor = UIColor.gray
private let kDefaultActiveSegmentType: SegmentType = .noSegment
private let kDefaultInactiveSegmentType: SegmentType = .noSegment
private let kDefaultSegmentSide: SegmentSide = .left

class AlarmTrackerSegmentView: UIView {
  var lineWidth: CGFloat = kDefaultLineWidth {
    didSet {
      setNeedsDisplay()
    }
  }

  var activeColor: UIColor = kDefaultActiveColor {
    didSet {
      setNeedsDisplay()
    }
  }

  var inactiveColor: UIColor = kDefaultInactiveColor {
    didSet {
      setNeedsDisplay()
    }
  }

  var activeSegmentType: SegmentType = kDefaultActiveSegmentType {
    didSet {
      setNeedsDisplay()
    }
  }

  var inactiveSegmentType: SegmentType = kDefaultInactiveSegmentType {
    didSet {
      setNeedsDisplay()
    }
  }

  var gradientLayer: CAGradientLayer = CAGradientLayer()
  var backgroundLayer: CALayer = CALayer()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    configureGradientLayer()
    configureBackgroundLayer()
  }

  func configureGradientLayer() {
    let colors = gradientColors(activeSegmentType)

    gradientLayer.bounds = CGRect(x: 0, y: 0, width: bounds.width + 10, height: bounds.size.height)
    gradientLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    gradientLayer.colors = [colors.startColor,
                            colors.midColor,
                            colors.endColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
    gradientLayer.opacity = 1.0
  }

  func configureBackgroundLayer() {
    backgroundLayer.bounds = CGRect(x: 0, y: 0, width: bounds.width + 10, height: bounds.size.height)
    backgroundLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    backgroundLayer.opacity = 1.0
    backgroundLayer.backgroundColor = inactiveColor.cgColor
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    configureGradientLayer()
    configureBackgroundLayer()

    mask = trackerSegmentMaskView(activeSegmentType,
                                      lineWidth: lineWidth)

    gradientLayer.removeFromSuperlayer()
    backgroundLayer.removeFromSuperlayer()

    layer.addSublayer(gradientLayer)
    layer.addSublayer(backgroundLayer)
    layer.insertSublayer(gradientLayer, above: backgroundLayer)
  }

  // swiftlint:disable:next line_length
  fileprivate func gradientColors(_ segmentType: SegmentType) -> (startColor: CGColor, midColor: CGColor, endColor: CGColor) {
    switch segmentType {
    case .noSegment, .inactive, .inactiveNone:
      return (startColor: UIColor.clear.cgColor,
              midColor: UIColor.clear.cgColor,
              endColor: UIColor.clear.cgColor)
    case .inactiveActive:
      return (startColor: UIColor.clear.cgColor,
              midColor: activeColor.cgColor,
              endColor: activeColor.cgColor)
    case .activeInactive:
      return (startColor: activeColor.cgColor,
              midColor: activeColor.cgColor,
              endColor: UIColor.clear.cgColor)
    case .activeNone:
      return (startColor: activeColor.cgColor,
              midColor: activeColor.cgColor,
              endColor: UIColor.clear.cgColor)
    }
  }

  func trackerSegmentMaskView(_ segmentType: SegmentType, lineWidth: CGFloat) -> UIView {
    let maskView: UIView = UIView()
    let maskLayer = CAShapeLayer()

    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    var height: CGFloat = 0
    if segmentType != .noSegment {
      height = lineWidth
    }

    maskLayer.addSublayer(trackerSegmentMask(center, height: height))

    maskView.layer.addSublayer(maskLayer)

    return maskView
  }

  func trackerSegmentMask(_ center: CGPoint, height: CGFloat) -> CAShapeLayer {
    let yOrigin = center.y - (height / 2)
    let rect = CGRect(x: -5, y: yOrigin, width: bounds.width + 10, height: height)

    let mask = CAShapeLayer()
    mask.path = UIBezierPath(rect: rect).cgPath
    mask.fillRule = kCAFillRuleEvenOdd

    return mask
  }
}
