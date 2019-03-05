//
//  ScleraWidget.swift
//  i2app
//
//  Created by Arcus Team on 9/27/17.
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

/**
 View with basic common customizations. 
 */
@IBDesignable
class ScleraWidget: UIView {

  /**
   Determines the curvature of the view's corners.
   */
  @IBInspectable var cornerRadius: CGFloat = 8.0 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }

  /**
   Shadow indicator for the widget.
   */
  @IBInspectable var hasShadow: Bool = false {
    didSet {
      if hasShadow {
        layer.shadowColor = ScleraColor.disabled.cgColor
        layer.shadowOpacity = 0.50
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
      } else {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0
      }
    }
  }
}
