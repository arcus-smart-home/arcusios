//
//  ArcusArcMath.swift
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

@objc class ArcusArcMath: NSObject {
    static func radians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * Double.pi / 180)
    }

    static func degrees(_ radians: CGFloat) -> Double {
        return Double(radians)/(Double.pi / 180)
    }

    static func pointForAngle(_ angle: CGFloat,
                              center: CGPoint,
                              radius: CGFloat) -> CGPoint {
        let angleX: CGFloat = round(center.x + radius * cos(angle))
        let angleY: CGFloat = round(center.y + radius * sin(angle))

        return CGPoint(x: angleX, y: angleY)
    }

    static func angleForPoint(_ point: CGPoint,
                              center: CGPoint) -> CGFloat {

        return atan2(point.y - center.y, point.x - center.x)
    }

    static func degreeForHue(_ hue: Double,
                             startDegree: Double,
                             endDegree: Double,
                             hueStartLimit: Double,
                             hueEndLimit: Double) -> Double {
        let hueRange = ArcusArcMath.hueRangeForLimits(hueStartLimit, hueEndLimit: hueEndLimit)

        var difference: Double = abs(endDegree - startDegree)
        if startDegree > endDegree {
            difference = (360 - startDegree) + endDegree
        }

        let differenceValue: Double = hueRange / difference

        let hueDegree: Double = (hue * 360) - hueStartLimit

        return round((startDegree + (hueDegree / differenceValue) + 360).truncatingRemainder(dividingBy: 360))
    }

    static func hueForDegree(_ degree: Double,
                             startDegree: Double,
                             endDegree: Double,
                             hueStartLimit: Double,
                             hueEndLimit: Double) -> Double {

        let hueRange = ArcusArcMath.hueRangeForLimits(hueStartLimit, hueEndLimit: hueEndLimit)

        var difference: Double = abs(endDegree - startDegree)
        if startDegree > endDegree {
            difference = (360 - startDegree) + endDegree
        }

        let differenceValue: Double = hueRange / difference
        let adjustedDegree: Double = degree - startDegree

        return round(adjustedDegree * differenceValue) + hueStartLimit
    }

    static func hueRangeForLimits(_ hueStartLimit: Double,
                                  hueEndLimit: Double) -> Double {
        var hueRange: Double = 360
        if hueStartLimit > 0 {
            hueRange -= hueStartLimit
        }

        if hueEndLimit < 360 {
            hueRange -= (360 - hueEndLimit)
        }

        return hueRange
    }
}
