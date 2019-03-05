//
//  ArcusButton.swift
//  i2app
//
//  Created by Arcus Team on 4/22/16.
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

@IBDesignable class ArcusButton: UIButton {
  let kerningValue: Double = 2

  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }

  @IBInspectable var borderColor: UIColor = UIColor.white {
    didSet {
      if layer.borderWidth > 0 {
        layer.borderColor = borderColor.cgColor
      }
    }
  }

  @IBInspectable var disableHighlightColor: Bool = false {
    didSet {
      updateTitleLabel()
    }
  }

  @IBInspectable var wideSpacing: Bool = false {
    didSet {
      updateTitleLabel()
    }
  }

  @IBInspectable var allCaps: Bool = false {
    didSet {
      updateTitleLabel()
    }
  }

  func updateTitleLabel() {
    var kerning: Double = 0
    if wideSpacing {
      kerning = kerningValue
    }
    var attributes = [NSFontAttributeName: titleLabel!.font,
                      NSKernAttributeName: kerning] as [String : Any]

    var hightlightedAttributes = [NSFontAttributeName: titleLabel!.font,
                                  NSKernAttributeName: kerning] as [String : Any]

    if !disableHighlightColor {
      attributes[NSForegroundColorAttributeName] = titleLabel!.textColor
      hightlightedAttributes[NSForegroundColorAttributeName] = titleLabel!.textColor.withAlphaComponent(0.4)
    }

    var title: String = ""
    if self.title(for: UIControlState()) != nil {
      title = self.title(for: UIControlState())!
    }
    if allCaps {
      title = title.uppercased()
    }

    let attributedString: NSAttributedString = NSAttributedString.init(string: title,
                                                                       attributes: attributes)
    let hightlightedAttributedString: NSAttributedString =
      NSAttributedString.init(string: title, attributes: hightlightedAttributes)

    setAttributedTitle(attributedString, for: .normal)
    setAttributedTitle(hightlightedAttributedString, for: .highlighted)
  }

  override func setTitle(_ title: String?, for state: UIControlState) {
    super.setTitle(title, for: state)
    updateTitleLabel()
  }
}
