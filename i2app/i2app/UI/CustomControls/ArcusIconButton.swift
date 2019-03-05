//
//  ArcusIconButton.swift
//  i2app
//
//  Created by Arcus Team on 2/21/17.
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

class ArcusVerticallyCenteredTextLayer: CATextLayer {
  override init() {
    super.init()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(layer: aDecoder)
  }

  override func draw(in ctx: CGContext) {
    let height = self.bounds.size.height
    let fontSize = self.fontSize
    let yValue = (height - fontSize) / 2 - fontSize / 10

    ctx.saveGState()
    ctx.translateBy(x: 0.0, y: yValue)

    super.draw(in: ctx)

    ctx.restoreGState()
  }
}

private let kKerningValue = 2.0

enum ArcusIconButtonIconSide: String {
  case None = "none"
  case Left = "left"
  case Right = "right"
}

@IBDesignable @objc class ArcusIconButton: UIControl {

  // MARK: IBInspectable Properties

  @IBInspectable var titleText: String = "" {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var fontFamily: String = "Helvetica Neue" {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var fontSize: CGFloat = 15.0 {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var textColor: UIColor = UIColor.black {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var highlightedTextColor: UIColor = UIColor.white {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var selectedTextColor: UIColor = UIColor.darkGray {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var disabledTextColor: UIColor = UIColor.lightGray {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var icon: UIImage? {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var iconSize: CGSize = CGSize.zero {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var iconSide: String = "none" {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var iconPadding: CGFloat = 8.0 {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
      setNeedsDisplay()
    }
  }

  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
      setNeedsDisplay()
    }
  }

  @IBInspectable var borderColor: UIColor = UIColor.white {
    didSet {
      if layer.borderWidth > 0 {
        layer.borderColor = borderColor.cgColor
        setNeedsDisplay()
      }
    }
  }

  @IBInspectable var wideSpacing: Bool = false {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var allCaps: Bool = false {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var highlightedBackgroundColor: UIColor? {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var selectedBackgroundColor: UIColor? {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var disabledBackgroundColor: UIColor? {
    didSet {
      setNeedsDisplay()
    }
  }

  // MARK: Public Properties

  var font: UIFont {
    if let newFont: UIFont = UIFont(name: fontFamily, size: fontSize) {
      return newFont
    }
    return UIFont.systemFont(ofSize: fontSize)

  }

  // MARK: Overridden UIControl Properties

  override var isSelected: Bool {
    didSet {
      setNeedsDisplay()
    }
  }

  override var isHighlighted: Bool {
    didSet {
      setNeedsDisplay()
    }
  }

  override var isEnabled: Bool {
    didSet {
      setNeedsDisplay()
    }
  }

  // MARK: Private Properties

  fileprivate var attributedTitle: NSAttributedString = NSAttributedString()
  fileprivate var buttonTextColor: UIColor = UIColor.white
  fileprivate var iconLayer: CAShapeLayer?
  fileprivate var textLayer: ArcusVerticallyCenteredTextLayer?
  fileprivate var buttonLayer: CALayer?
  fileprivate var buttonMaskLayer: CALayer?
  fileprivate var buttonBackgroundLayer: CALayer?
  fileprivate var buttonBackgroundColor: UIColor?

  // MARK: Init

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    commonConfig()
  }

  // MARK: Overridden UIControl Functions

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonConfig()
  }

  override func setNeedsDisplay() {
    super.setNeedsDisplay()

    updateTitleLabel()
    updateCurrentColor()
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    updateLayers()
    buttonLayer!.removeFromSuperlayer()
    buttonBackgroundLayer!.removeFromSuperlayer()
    self.layer.addSublayer(buttonLayer!)
    self.layer.insertSublayer(buttonBackgroundLayer!, below: buttonLayer!)
  }

  // MARK: Config/Layout Functions

  fileprivate func commonConfig() {
    updateTitleLabel()
    updateCurrentColor()
  }

  fileprivate func updateTitleLabel() {
    var kern: Double = 0
    if wideSpacing {
      kern = kKerningValue
    }
    let attributes: [String : AnyObject] = [NSFontAttributeName: font,
                                            NSKernAttributeName: kern as AnyObject,
                                            NSForegroundColorAttributeName: buttonTextColor.cgColor]

    var title: String = titleText
    if allCaps {
      title = title.uppercased()
    }

    attributedTitle = NSAttributedString.init(string: title,
                                              attributes: attributes)
  }

  fileprivate func updateCurrentColor() {
    buttonTextColor = textColor
    buttonBackgroundColor = backgroundColor

    if isSelected == true {
      buttonTextColor = selectedTextColor
      buttonBackgroundColor = selectedBackgroundColor
    } else if isHighlighted == true {
      buttonTextColor = highlightedTextColor
      buttonBackgroundColor = highlightedBackgroundColor
    } else if isEnabled == false {
      buttonTextColor = disabledTextColor
      buttonBackgroundColor = disabledBackgroundColor
    } else {
      buttonBackgroundColor = backgroundColor
    }
  }

  fileprivate func updateLayers() {
    buttonBackgroundLayer = visualInteractionMask(bounds, color: buttonBackgroundColor)
    buttonMaskLayer = buttonMask(bounds)
    textLayer = textMask(iconPadding, iconSide: iconSide)

    if icon != nil {
      let containingRect = imageRect(attributedTitle,
                                     bounds: bounds,
                                     size: iconSize,
                                     padding: iconPadding,
                                     side: iconSide)
      iconLayer = imageMask(icon!, containingRect: containingRect)
    }

    buttonMaskLayer!.addSublayer(iconLayer!)
    buttonMaskLayer!.addSublayer(textLayer!)

    if buttonLayer == nil {
      buttonLayer = CALayer()
    }
    buttonLayer!.backgroundColor = buttonTextColor.cgColor
    buttonLayer!.bounds = bounds
    buttonLayer!.mask = buttonMaskLayer
    buttonLayer!.position = CGPoint(x: bounds.midX, y: bounds.midY)
  }

  // MARK: Masking/Layer Functions

  fileprivate func imageMask(_ image: UIImage, containingRect: CGRect) -> CAShapeLayer {
    var size: CGSize = CGSize(width: 100, height: 100)

    if image.size.width != 0 && image.size.height != 0 {
      size = image.size
    }

    let imageMask = CAShapeLayer()
    imageMask.bounds = AVMakeRect(aspectRatio: size, insideRect: containingRect)
    imageMask.contents = image.cgImage
    imageMask.fillMode = kCAFillRuleEvenOdd
    imageMask.position = CGPoint(x: containingRect.midX,
                                 y: containingRect.midY)

    return imageMask
  }

  fileprivate func textMask(_ padding: CGFloat, iconSide: String) -> ArcusVerticallyCenteredTextLayer {
    let textMask = ArcusVerticallyCenteredTextLayer()
    textMask.alignmentMode = kCAAlignmentCenter
    textMask.bounds = bounds
    textMask.contentsScale = UIScreen.main.scale
    textMask.foregroundColor = UIColor.black.cgColor
    textMask.font = font
    textMask.fontSize = font.pointSize
    textMask.position = textPosition(bounds,
                                     padding: padding,
                                     side: iconSide)
    textMask.string = attributedTitle
    textMask.truncationMode = kCATruncationNone
    textMask.isWrapped = false

    return textMask
  }

  fileprivate func buttonMask(_ bounds: CGRect) -> CAShapeLayer {
    let mask = CAShapeLayer()
    mask.bounds = bounds
    mask.fillColor = UIColor.clear.cgColor
    mask.fillMode = kCAFillRuleEvenOdd
    mask.position = CGPoint(x: bounds.midX,
                            y: bounds.midY)

    return mask
  }

  fileprivate func visualInteractionMask(_ bounds: CGRect, color: UIColor?) -> CALayer {
    let visualMask = CALayer()
    visualMask.bounds = bounds
    visualMask.position = CGPoint(x: bounds.midX, y: bounds.midY)

    if color != nil {
      visualMask.backgroundColor = color!.cgColor
      visualMask.opacity = Float(color!.rgba().alpha)
    } else {
      visualMask.backgroundColor = UIColor.clear.cgColor
      visualMask.opacity = 0.0
    }

    return visualMask
  }

  // MARK: Size/Position Functions

  fileprivate func imageRect(_ text: NSAttributedString,
                             bounds: CGRect,
                             size: CGSize,
                             padding: CGFloat,
                             side: String) -> CGRect {

    let textSize: CGSize = self.textSize(text, size: bounds.size)
    let offset = padding / 2 + textSize.width / 2

    if side == ArcusIconButtonIconSide.Left.rawValue {
      return CGRect(x: bounds.midX - size.width - offset,
                    y: bounds.midY - size.height / 2,
                    width: size.width,
                    height: size.height)
    } else if side == ArcusIconButtonIconSide.Right.rawValue {
      return CGRect(x: bounds.midX + offset,
                    y: bounds.midY - size.height / 2,
                    width: size.width,
                    height: size.height)
    }
    return CGRect()
  }

  func textPosition(_ bounds: CGRect, padding: CGFloat, side: String) -> CGPoint {
    let adjustedPadding = padding / 2
    if side == ArcusIconButtonIconSide.Left.rawValue {
      return CGPoint(x: bounds.midX + adjustedPadding,
                     y: bounds.midY)
    } else if side == ArcusIconButtonIconSide.Right.rawValue {
      return CGPoint(x: bounds.midX - adjustedPadding,
                     y: bounds.midY)
    }
    return CGPoint(x: bounds.midX,
                   y: bounds.midY)
  }

  func textSize(_ text: NSAttributedString, size: CGSize) -> CGSize {
    let rect: CGRect = text
      .boundingRect(with: size,
                    options: .usesLineFragmentOrigin,
                    context: nil)
    return CGSize(width: ceil(rect.size.width),
                  height: ceil(rect.size.height))
  }
}
