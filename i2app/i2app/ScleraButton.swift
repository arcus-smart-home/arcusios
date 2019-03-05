//
//  ScleraButton.swift
//  i2app
//
//  Created by Arcus Team on 10/13/17.
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

/**
 This class can be configured to represent the different variations of Sclera style buttons.
 */
@IBDesignable class ScleraButton: UIButton {

  /**
   The coner radius of the button.
   */
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      setNeedsLayout()
    }
  }

  /**
   The width of the button's border. If setting this value the borderColor property should also be considered.
   */
  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      setNeedsLayout()
    }
  }

  /**
   The color of the button's border.
   */
  @IBInspectable var borderColor: UIColor = UIColor.white {
    didSet {
      setNeedsLayout()
    }
  }

  /**
   Ensures that the text in the button is capitalized.
   */
  @IBInspectable var hasCaps: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }

  /**
   Puts an underline under the button text.
   */
  @IBInspectable var isUnderlined: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }
  
  /**
   Makes the button take on a gray color when it is disabled.
   */
  @IBInspectable var grayOnDisable: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }
  
  private var enabledBackgroundColor: UIColor?
  
  private var activityIndicator: UIActivityIndicatorView?

  // Overrides
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    updateButton()
  }
  
  override func layoutSubviews() {
    updateButton()
    super.layoutSubviews()
  }

  override func setImage(_ image: UIImage?, for state: UIControlState) {
    super.setImage(image, for: state)
    setNeedsLayout()
  }

  override func setTitle(_ title: String?, for state: UIControlState) {
    super.setTitle(title, for: .normal)
    setNeedsLayout()
  }
  
  override var isEnabled: Bool {
    didSet {
      if isEnabled {
        if let enabledColor = enabledBackgroundColor {
          backgroundColor = enabledColor
          enabledBackgroundColor = nil
        }
      } else {
        if grayOnDisable && backgroundColor != ScleraColor.disabled {
          enabledBackgroundColor = backgroundColor
          backgroundColor = ScleraColor.disabled
        }        
      }
    }
  }
  
  // public functions
  
  /**
   Adds a loading indicator in the middle of the button.
   */
  func startLoadingIndicator() {
    // Using the opacity to hide the text behind the loading indicator as `titileLabel?.isHidden = true`
    // does not work as expected in a UIButton.
    titleLabel?.layer.opacity = 0
    isUserInteractionEnabled = false
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    indicator.frame.origin = CGPoint(x: (frame.width/2) - indicator.frame.width/2,
                                     y: (frame.height/2) - indicator.frame.height/2)
    addSubview(indicator)
    indicator.startAnimating()
    activityIndicator = indicator
  }
  
  /**
   Removes the loading indicator from the button if there is one being displayed.
   */
  func stopLoadingIndicator() {
    titleLabel?.layer.opacity = 1
    isUserInteractionEnabled = true
    activityIndicator?.stopAnimating()
    activityIndicator?.removeFromSuperview()
    activityIndicator = nil
  }

  // private functions

  private func updateButton() {
    var textAttributes: [String: Any] = [:]
    var title = ""

    if let text = self.title(for: .normal) {
      title = text
    }

    if let text = self.attributedTitle(for: .normal) {
      var range = NSRange(location: 0, length: text.length)
      let attributes = text.attributes(at: 0, effectiveRange: &range)
      textAttributes.merge(attributes)
    }

    var color = UIColor.black
    if let normalColor = self.titleColor(for: .normal) {
      color = normalColor
    }
    if hasCaps {
      title = title.uppercased()
    }

    if isUnderlined {
      textAttributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue
    }
    textAttributes[NSForegroundColorAttributeName] = color

    let attributedTitle = NSAttributedString.init(string: title,
                                                  attributes: textAttributes)

    setAttributedTitle(attributedTitle, for: .normal)

    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor.cgColor
  }
}
