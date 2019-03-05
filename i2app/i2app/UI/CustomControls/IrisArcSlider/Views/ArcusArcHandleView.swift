//
//  ArcusArcHandleView.swift
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

@objc class ArcusArcHandleView: UIView {
  var centerPoint = CGPoint()
  var radius: CGFloat = 0
  var width: CGFloat = 0
  var currentAngle: CGFloat = 0
  var color = UIColor.white
  var shadowColor = UIColor.clear

  override func draw(_ rect: CGRect) {
    if let context = UIGraphicsGetCurrentContext() {
      ArcusArcDrawing.drawHandle(context,
                                center: centerPoint,
                                radius: radius,
                                width: width,
                                angle: currentAngle,
                                color: color,
                                shadowColor: shadowColor)
    }
  }
}
