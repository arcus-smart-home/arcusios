//
//  ArcusArcView.swift
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

import UIKit

@objc enum ArcMode: Int {
    case colorArray = 0
    case hueBased = 1
}

@IBDesignable @objc class ArcusArcView: UIView {
    @IBInspectable var centerPoint: CGPoint = CGPoint()
    @IBInspectable var radius: CGFloat = 0
    @IBInspectable var width: CGFloat = 0
    @IBInspectable var startAngle: CGFloat = 0
    @IBInspectable var endAngle: CGFloat = 0
    @IBInspectable var hueRangeStart: Double = 0
    @IBInspectable var hueRangeEnd: Double = 360
    @IBInspectable var squareCap: Bool = false
    @IBInspectable var colorsArray: [UIColor]! = [] {
        didSet {
            if colorsArray.count > 0 {
                arcMode = .colorArray
            }
        }
    }

    var arcMode: ArcMode = .colorArray

    override func draw(_ rect: CGRect) {
      if let context = UIGraphicsGetCurrentContext() {
        ArcusArcDrawing.drawBackgroundMask(context,
                                          center: centerPoint,
                                          radius: radius,
                                          lineWidth: width,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          squareCap: squareCap)

        if arcMode == .colorArray {
          ArcusArcDrawing.drawBackgroundArc(context,
                                           center: centerPoint,
                                           radius: radius,
                                           startAngle: startAngle,
                                           endAngle: endAngle,
                                           colorsArray: colorsArray)
        } else if arcMode == .hueBased {
          ArcusArcDrawing.drawHueBasedBackgroundArc(context,
                                                   center: centerPoint,
                                                   radius: radius,
                                                   startAngle: startAngle,
                                                   endAngle: endAngle,
                                                   hueStartValue: hueRangeStart,
                                                   hueEndValue: hueRangeEnd)
        }
      }
    }
}
