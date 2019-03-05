//
//  ArcusGradientView.swift
//  i2app
//
//  Created by Arcus Team on 2/19/18.
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

@IBDesignable 
class ArcusGradientView: UIView {

  fileprivate var gradientLayer = CAGradientLayer()

  @IBInspectable var gradientColorTop: UIColor =   UIColor(red:0, green:0.75, blue:0.7, alpha:1) {
    didSet {
      updateGradient()
    }
  }

  @IBInspectable var gradientColorBottom: UIColor = UIColor(red:0, green:0.58, blue:0.78, alpha:1) {
    didSet {
      updateGradient()
    }
  }
  
  @IBInspectable var addToBackLayer: Bool = false {
    didSet {
      updateGradient()
    }
  }
  
  /**
   Determines if the gradident is vertical or horizontal.
   */
  @IBInspectable var horizontalGradient: Bool = false {
    didSet {
      updateGradient()
    }
  }

  override func layoutSubviews() {
    updateGradient()
    super.layoutSubviews()
  }

  fileprivate func updateGradient() {

    let top = gradientColorTop.cgColor as CGColor
    let bottom = gradientColorBottom.cgColor as CGColor

    gradientLayer.frame = self.bounds
    gradientLayer.colors = [top, bottom]
    
    if horizontalGradient {
      gradientLayer.startPoint = .zero
      gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    } else {
      gradientLayer.locations = [0.0, 1.0]
    }
    
    if addToBackLayer {
      layer.insertSublayer(gradientLayer, at: 0)
    } else {
      layer.addSublayer(gradientLayer)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    updateGradient()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    updateGradient()
  }

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    updateGradient()
  }
  
}
