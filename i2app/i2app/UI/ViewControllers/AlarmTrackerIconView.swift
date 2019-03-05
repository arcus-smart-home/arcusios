//
//  AlarmTrackerIconView.swift
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

enum AlarmTrackerIconState {
  case hidden
  case activeIcon
  case inactiveIcon
  case inactiveCountdown
}

private let kDefaultRingWidth: CGFloat = 10.0
private let kDefaultRadius: CGFloat = 46.0
private let kDefaultActiveColor: UIColor = UIColor.red
private let kDefaultInactiveColor: UIColor = UIColor.gray

class AlarmTrackerIconView: UIView {
  var ringWidth: CGFloat = kDefaultRingWidth {
    didSet {
      setNeedsDisplay()
    }
  }

  var icon: UIImage? = UIImage(named: "") {
    didSet {
      setNeedsDisplay()
    }
  }

  var radius: CGFloat = kDefaultRadius {
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

  var attributedText: NSAttributedString? {
    didSet {
      setNeedsDisplay()
    }
  }

  var backgroundLayer: CALayer = CALayer()
  var foregroundLayer: CALayer = CALayer()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    configureBackgroundLayer()
    configureForegroundLayer()
  }

  func configureForegroundLayer() {
    foregroundLayer.bounds = CGRect(x: bounds.width / -2,
                                    y: bounds.height / -2,
                                    width: bounds.width * 2,
                                    height: bounds.height * 2)
    foregroundLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    foregroundLayer.backgroundColor = activeColor.cgColor
    if activeIconState == .hidden {
      foregroundLayer.backgroundColor = UIColor.clear.cgColor
    } else {
      foregroundLayer.backgroundColor = activeColor.cgColor
    }
  }

  func configureBackgroundLayer() {
    backgroundLayer.bounds = CGRect(x: bounds.width / -2,
                                    y: bounds.height / -2,
                                    width: bounds.width * 2,
                                    height: bounds.height * 2)
    backgroundLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    if inactiveIconState == .hidden {
      backgroundLayer.backgroundColor = UIColor.clear.cgColor
    } else {
      backgroundLayer.backgroundColor = inactiveColor.cgColor
    }
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let rect = CGRect(x: ceil(bounds.size.width * 0.32),
                      y: ceil(bounds.size.height * 0.32),
                      width: ceil(bounds.size.width * 0.36),
                      height: ceil(bounds.size.height * 0.36))

    mask = trackerStateMaskView(icon,
                                    imageRect: rect,
                                    lineWidth: ringWidth,
                                    radius: radius)

    configureBackgroundLayer()
    configureForegroundLayer()
    layer.addSublayer(backgroundLayer)
    layer.insertSublayer(foregroundLayer, above: backgroundLayer)
  }

  func trackerTimerTextMask() -> ArcusVerticallyCenteredTextLayer {
    let textMask = ArcusVerticallyCenteredTextLayer()
    textMask.alignmentMode = kCAAlignmentCenter
    textMask.bounds = bounds
    textMask.contentsScale = UIScreen.main.scale
    textMask.foregroundColor = UIColor.black.cgColor
    textMask.position = CGPoint(x: bounds.midX, y: bounds.midY)
    textMask.string = attributedText
    textMask.truncationMode = kCATruncationNone
    textMask.isWrapped = false

    return textMask
  }

  func trackerStateMaskView(_ image: UIImage?,
                            imageRect: CGRect,
                            lineWidth: CGFloat,
                            radius: CGFloat) -> UIView {
    let maskView: UIView = UIView()
    let maskLayer = CAShapeLayer()

    let ringCenter = CGPoint(x: bounds.midX, y: bounds.midY)

    if attributedText != nil {
      maskLayer.addSublayer(trackerTimerTextMask())
    } else {
      maskLayer.addSublayer(trackerStateImageMask(image, containingRect: imageRect))
    }
    maskLayer.addSublayer(trackerStateRingMask(radius, center: ringCenter, width: lineWidth))

    maskView.layer.addSublayer(maskLayer)

    return maskView
  }

  func trackerStateImageMask(_ image: UIImage?, containingRect: CGRect) -> CAShapeLayer {
    var size: CGSize = CGSize(width: 100, height: 100)
    if image?.size != nil {
      size = image!.size
    }
    
    let mask = CAShapeLayer()
    mask.contentsScale = UIScreen.main.scale
    mask.frame = AVMakeRect(aspectRatio: size, insideRect: containingRect)
    mask.position = CGPoint(x: ceil(bounds.midX), y: ceil(bounds.midY))
    mask.contents = image?.cgImage
    mask.fillRule = kCAFillRuleEvenOdd

    return mask
  }

  func trackerStateRingMask(_ radius: CGFloat, center: CGPoint, width: CGFloat) -> CAShapeLayer {
    // Ring Mask
    let circlePath = UIBezierPath(arcCenter: center,
                                  radius: radius,
                                  startAngle: CGFloat(0),
                                  endAngle:CGFloat(Double.pi * 2),
                                  clockwise: true)

    let mask = CAShapeLayer()
    mask.path = circlePath.cgPath
    mask.lineWidth = width
    mask.fillRule = kCAFillRuleEvenOdd
    mask.fillColor = UIColor.clear.cgColor
    mask.strokeColor = UIColor.white.cgColor

    return mask
  }
}
