//
//  ArcusArcDrawing.swift
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

@objc class ArcusArcDrawing: NSObject {
  static func drawBackgroundMask(_ context: CGContext,
                                 center: CGPoint,
                                 radius: CGFloat,
                                 lineWidth: CGFloat,
                                 startAngle: CGFloat,
                                 endAngle: CGFloat,
                                 squareCap: Bool = false) {
    context.setLineWidth(lineWidth)

    if !squareCap {
      context.setLineCap(.round)
    }

    context.addArc(center: center,
                   radius: radius,
                   startAngle: startAngle,
                   endAngle: endAngle,
                   clockwise: false)

    context.replacePathWithStrokedPath()
    context.clip()
  }

  static func drawBackgroundArc(_ context: CGContext,
                                center: CGPoint,
                                radius: CGFloat,
                                startAngle: CGFloat,
                                endAngle: CGFloat,
                                colorsArray: [UIColor]) {
    if colorsArray.count > 0 {
      let startDegree: Int = Int(ArcusArcMath.degrees(startAngle))
      let endDegree: Int = Int(ArcusArcMath.degrees(endAngle))

      if colorsArray.count == 1 {
        context.setLineWidth(radius)
        context.setLineCap(.round)

        context.addArc(center: center,
                       radius: radius,
                       startAngle: startAngle,
                       endAngle: endAngle,
                       clockwise: false)
        context.setStrokeColor(colorsArray[0].cgColor)
        context.strokePath()

        return
      }

      var difference: Int = abs(endDegree - startDegree)
      if startDegree > endDegree {
        difference = (360 - startDegree) + endDegree
      }

      if difference < 350 {
        let adjustedStartAngle: CGFloat = startAngle - ArcusArcMath.radians(20)
        let adjustedEndAngle: CGFloat = endAngle + ArcusArcMath.radians(20)

        let midAngle: CGFloat = ArcusArcMath
          .radians(Double(startDegree + (difference / 2)))

        let startColor: UIColor = colorsArray[0]
        let endColor: UIColor = colorsArray[colorsArray.count - 1]

        context.setLineWidth(radius)
        context.setLineCap(.butt)

        context.addArc(center: center,
                       radius: radius,
                       startAngle: adjustedStartAngle,
                       endAngle: midAngle,
                       clockwise: false)
        context.setStrokeColor(startColor.cgColor)
        context.strokePath()

        context.addArc(center: center,
                       radius: radius,
                       startAngle: midAngle,
                       endAngle: adjustedEndAngle,
                       clockwise: false)
        context.setStrokeColor(endColor.cgColor)
        context.strokePath()

        context.setLineWidth(radius)
        context.setLineCap(.butt)
      }

      let paddedDifference = difference * 2
      let colorCount: Int = colorsArray.count

      var colorStep: Int = paddedDifference
      if colorCount > 1 {
        colorStep = paddedDifference / (colorCount - 1)
      }

      let arcStep: CGFloat = CGFloat((Double.pi * 2) / 360)

      var currentStep: Int = -1
      var nextStep: Int = 0

      for i in 0..<(paddedDifference) {
        let indexDegree: Double = ((Double(i) / 2) + Double(startDegree)).truncatingRemainder(dividingBy: 360)

        if i % colorStep == 0 {
          currentStep += 1
          nextStep += 1
        }

        if currentStep >= 0 && nextStep < colorCount {
          let percent: Double =
            Double(i - (currentStep * colorStep)) / Double(colorStep)
          let start: UIColor = colorsArray[currentStep]
          let end: UIColor = colorsArray[nextStep]
          let color: UIColor = UIColor.interpolatedColor(percent,
                                                         startColor: start,
                                                         endColor: end)

          context.setStrokeColor(color.cgColor)
        }

        let start: CGFloat = CGFloat(indexDegree) * arcStep - 0.1
        let end: CGFloat = start + arcStep + 0.1

        context.addArc(center: center,
                       radius: radius,
                       startAngle: start,
                       endAngle: end,
                       clockwise: false)
        context.strokePath()
      }
    }
  }

  static func drawHueBasedBackgroundArc(_ context: CGContext,
                                        center: CGPoint,
                                        radius: CGFloat,
                                        startAngle: CGFloat,
                                        endAngle: CGFloat,
                                        hueStartValue: Double,
                                        hueEndValue: Double) {

    let startDegree: Int = Int(ArcusArcMath.degrees(startAngle))
    let endDegree: Int = Int(ArcusArcMath.degrees(endAngle))

    var difference: Int = abs(endDegree - startDegree)
    if startDegree > endDegree {
      difference = (360 - startDegree) + endDegree
    }

    if difference < 350 {
      let adjustedStartAngle: CGFloat = startAngle - ArcusArcMath.radians(20)
      let adjustedEndAngle: CGFloat = endAngle + ArcusArcMath.radians(20)

      let midAngle: CGFloat = ArcusArcMath
        .radians(Double(startDegree + (difference / 2)))

      let startColor: UIColor = UIColor(hue: CGFloat(hueStartValue) / 360.0,
                                        saturation: 0.75,
                                        brightness: 1.0,
                                        alpha: 1.0)

      let endColor: UIColor = UIColor(hue: CGFloat(hueEndValue) / 360.0,
                                      saturation: 0.75,
                                      brightness: 1.0,
                                      alpha: 1.0)

      context.setLineWidth(radius)
      context.setLineCap(.butt)

      context.addArc(center: center,
                     radius: radius,
                     startAngle: adjustedStartAngle,
                     endAngle: midAngle,
                     clockwise: false)
      context.setStrokeColor(startColor.cgColor)
      context.strokePath()

      context.addArc(center: center,
                     radius: radius,
                     startAngle: midAngle,
                     endAngle: adjustedEndAngle,
                     clockwise: false)
      context.setStrokeColor(endColor.cgColor)
      context.strokePath()

      context.setLineWidth(radius)
      context.setLineCap(.butt)

    }

    let arcStep: CGFloat = CGFloat((Double.pi * 2) / 360)

    for i in 0..<(difference) {

      let hue: CGFloat = CGFloat(ArcusArcMath.hueForDegree(Double(i + startDegree),
                                                          startDegree: Double(startDegree),
                                                          endDegree: Double(endDegree),
                                                          hueStartLimit: hueStartValue,
                                                          hueEndLimit: hueEndValue))

      let color: UIColor = UIColor(hue: hue / 360,
                                   saturation: 0.75,
                                   brightness: 1.0,
                                   alpha: 1.0)

      context.setStrokeColor(color.cgColor)

      let indexDegree: Double = (Double(i) + Double(startDegree)).truncatingRemainder(dividingBy: 360)
      let start: CGFloat = CGFloat(indexDegree) * arcStep - 0.1
      let end: CGFloat = start + arcStep + 0.1

      context.addArc(center: center,
                     radius: radius,
                     startAngle: start,
                     endAngle: end,
                     clockwise: false)
      context.strokePath()
    }
  }

  static func drawHandle(_ context: CGContext,
                         center: CGPoint,
                         radius: CGFloat,
                         width: CGFloat,
                         angle: CGFloat,
                         color: UIColor,
                         shadowColor: UIColor) {
    let handleRadius = width / 2
    let pointForAngle: CGPoint = ArcusArcMath.pointForAngle(angle,
                                                           center: center,
                                                           radius: radius)

    context.saveGState()

    context.setShadow(offset: CGSize(width: 1.0, height: 1.0),
                      blur: 5.0,
                      color: shadowColor.cgColor)

    color.set()

    context.fillEllipse(in: CGRect(x: pointForAngle.x - handleRadius,
                                      y: pointForAngle.y - handleRadius,
                                      width: width,
                                      height: width))

    context.restoreGState()
  }
}
