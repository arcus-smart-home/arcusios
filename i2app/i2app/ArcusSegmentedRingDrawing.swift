//
//  ArcusSegmentedRingDrawing.swift
//  i2app
//
//  Created by Arcus Team on 12/19/16.
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

protocol ArcusSegmentedRingDrawing {
  func drawGlowArc(_ startAngle: CGFloat,
                   endAngle: CGFloat,
                   center: CGPoint,
                   radius: CGFloat,
                   lineWidth: CGFloat,
                   strokeColor: UIColor)

  func drawArc(_ startAngle: CGFloat,
               endAngle: CGFloat,
               center: CGPoint,
               radius: CGFloat,
               lineWidth: CGFloat,
               strokeColor: UIColor)
}

extension ArcusSegmentedRingDrawing {
  func drawGlowArc(_ startAngle: CGFloat,
                   endAngle: CGFloat,
                   center: CGPoint,
                   radius: CGFloat,
                   lineWidth: CGFloat,
                   strokeColor: UIColor) {
    guard let context: CGContext = UIGraphicsGetCurrentContext() else {
      return
    }

    let arc: UIBezierPath = UIBezierPath(arcCenter: center,
                                         radius: radius,
                                         startAngle: startAngle,
                                         endAngle: endAngle,
                                         clockwise: true)

    strokeColor.setStroke()

    context.saveGState()

    context.setShadow(offset: CGSize(width: 0, height: 0), blur: lineWidth * 2, color: strokeColor.cgColor)

    arc.lineWidth = CGFloat(lineWidth)
    arc.fill()
    arc.stroke()

    context.restoreGState()
  }

  func drawArc(_ startAngle: CGFloat,
               endAngle: CGFloat,
               center: CGPoint,
               radius: CGFloat,
               lineWidth: CGFloat,
               strokeColor: UIColor) {
    UIColor.clear.setFill()
    strokeColor.setStroke()

    let arc: UIBezierPath = UIBezierPath(arcCenter: center,
                                         radius: radius,
                                         startAngle: startAngle,
                                         endAngle: endAngle,
                                         clockwise: true)
    arc.lineWidth = CGFloat(lineWidth)
    arc.fill()
    arc.stroke()
  }
}
