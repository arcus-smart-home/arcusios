//
//  ArcusAlarmRingView.swift
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

enum ArcusAlarmRingSegmentState: String {
  case unknown = "Unknown"
  case active = "Active"
  case inactive = "Inactive"
  case offline = "Offline"
}

let kDefaultAlarmRingWidth: CGFloat = 5.0

@IBDesignable class ArcusAlarmRingView: UIView, ArcusSegmentedRingDrawing {
  @IBInspectable var ringWidth: CGFloat = kDefaultAlarmRingWidth {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var activeColor: UIColor = UIColor.white {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var inactiveColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6) {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var offlineColor = ObjCMacroAdapter.arcusPinkAlertColor() {
    didSet {
      setNeedsDisplay()
    }
  }

  var segments: [ArcusAlarmRingSegmentState]! = [] {
    didSet {
      setNeedsDisplay()
    }
  }

  // MARK: View Life Cycle

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    drawRingSegments(segments, lineWidth: ringWidth)
  }

  func drawRingSegments(_ segments: [ArcusAlarmRingSegmentState], lineWidth: CGFloat) {
    guard segments.count > 0 else {
      return
    }

    let fillColor = UIColor.clear
    fillColor.setFill()

    var arcStartAngle: CGFloat = CGFloat(-(Double.pi / 2))

    let numberOfSegments = segments.count
    if numberOfSegments > 1 {
      for index in 0...(numberOfSegments-1) {
        let segmentType = segments[index]
        let percentage: CGFloat = CGFloat(1.0 / Double(numberOfSegments))
        let endDegree = ArcusArcMath.degrees(arcStartAngle + (percentage * 2.0 * CGFloat.pi)) - 5.0
        let arcEndAngle: CGFloat = ArcusArcMath.radians(endDegree)
        let startDegree = ArcusArcMath.degrees(arcStartAngle) + 2.5

        arcStartAngle = ArcusArcMath.radians(startDegree)

        drawSegment(segmentType,
                    startAngle: arcStartAngle,
                    endAngle: arcEndAngle,
                    lineWidth: lineWidth)

        arcStartAngle = ArcusArcMath.radians(endDegree + 5.0)
      }
    } else if numberOfSegments == 1 {
      let segmentType = segments[0]
      let arcEndAngle: CGFloat = ArcusArcMath.radians(360)

      drawSegment(segmentType,
                  startAngle: arcStartAngle,
                  endAngle: arcEndAngle,
                  lineWidth: lineWidth)
    }
  }

  func drawSegment(_ segmentState: ArcusAlarmRingSegmentState,
                   startAngle: CGFloat,
                   endAngle: CGFloat,
                   lineWidth: CGFloat) {

    let strokeColor: UIColor = segmentColorForState(segmentState)
    let center: CGPoint = CGPoint(x: bounds.origin.x + bounds.size.width / 2.0,
                                  y: bounds.origin.y + bounds.size.height / 2.0)
    let radius: CGFloat = (frame.size.width / 2.0 - (lineWidth * 2))

    if segmentState == .active {
      drawGlowArc(startAngle,
                  endAngle: endAngle,
                  center: center,
                  radius: radius,
                  lineWidth: lineWidth,
                  strokeColor: strokeColor)
    } else {
      drawArc(startAngle,
              endAngle: endAngle,
              center: center,
              radius: radius,
              lineWidth: lineWidth,
              strokeColor: strokeColor)
    }
  }

  func segmentColorForState(_ segmentState: ArcusAlarmRingSegmentState) -> UIColor {
    switch segmentState {
    case .active:
      return activeColor
    case .inactive:
      return inactiveColor
    case .offline:
      return offlineColor!
    default:
      return UIColor.clear
    }
  }
}
