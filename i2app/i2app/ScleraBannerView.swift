//
//  ScleraBannerView.swift
//  i2app
//
//  Created by Arcus Team on 10/5/17.
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

/**
  Class designed to accomodate the common use cases of a banner view. By default, this class will use
  the ArcusBannerView prototype to layout it's elements. A different prototype can be specified through
  the appropiate class initializer or the prototypeName inspectable variable in the storyboard. Changing 
  the prototypeName property after the element is initialized will not have any effect.
 */
@IBDesignable
class ScleraBannerView: UIView, NibConfigurable {

  /**
   The icon element to be displayed in the banner.
   */
  @IBOutlet weak var icon: UIImageView?

  /**
   Label containing the main text of the banner.
   */
  @IBOutlet weak var mainText: UITextView?

  /**
   The color used for the banner text and icon.
   */
  @IBInspectable var textColor: UIColor = ScleraColor.disabled {
    didSet {
      updateTextColor()
    }
  }

  /**
   Required by NibConfigurable
   */
  @IBInspectable var prototypeName: String? = "" {
    didSet {
      loadPrototype()
    }
  }

  /**
   Required by NibConfigurable
   */
  var prototypeView: UIView?

  /**
   The text to be displayed on the banner.
   */
  @IBInspectable var contentText: String = "Banner Text" {
    didSet {
      updateText()
    }
  }

  /**
   The name of the image to be used as the icon of the banner.
   */
  @IBInspectable var imageName: String = "" {
    didSet {
      updateImage()
    }
  }

  override func awakeFromNib() {
    loadPrototype()
    updateImage()
    updateText()
    updateTextColor()
  }

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    loadPrototype()
    prototypeView?.prepareForInterfaceBuilder()
    updateImage()
    updateText()
    updateTextColor()
  }

  /**
   Makes the banner visible.
  */
  func show() {
    guard isHidden else {
      return
    }
    
    alpha = 0
    isHidden = false

    UIView.animate(withDuration: 0.25, animations: {
      self.alpha = 1.0
    })
  }

  /**
   Hides the banner view.
   */
  func hide() {
    UIView.animate(withDuration: 0.25, animations: {
      self.alpha = 0.0
    }) { _ in
      // After fading out hide the entire view
      self.isHidden = true
    }
  }

  private func updateTextColor() {
    if let mainText = mainText {
      mainText.textColor = textColor
    }

    if let icon = icon, icon.image != nil {
      icon.image = icon.image!.withRenderingMode(.alwaysTemplate)
      icon.tintColor = textColor
    }
  }

  private func updateText() {
    guard let mainText = mainText else {
      return
    }

    mainText.text = contentText

    var font: UIFont = UIFont()
    if mainText.font != nil {
      font = mainText.font!
    }

    mainText.linkTextAttributes = [
      NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
      NSFontAttributeName: font
    ]
  }

  private func updateImage() {
    guard let icon = icon else {
      return
    }

    if imageName.isEmpty {
      icon.isHidden = true
    } else {
      icon.isHidden = false

      let bundle = Bundle(for: type(of: self))
      let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
      icon.image = image
    }
  }
}
