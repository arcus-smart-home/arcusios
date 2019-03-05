//
//  ArcusArcSlider.swift
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

@IBDesignable @objc class ArcusArcSlider: UIControl {
    // Internal Views
    fileprivate var arcView: ArcusArcView!
    fileprivate var handleView: ArcusArcHandleView!

    // ValueChange() Properties - Read Only
    fileprivate(set) var selectedColor: UIColor = UIColor.clear
    fileprivate(set) var currentValue: Double = 0.0

    @IBInspectable var startDegrees: Double = 0 {
        didSet {
            adjustedStartAngle = ArcusArcMath.radians(startDegrees)
        }
    }

    @IBInspectable var endDegrees: Double = 0 {
        didSet {
            adjustedEndAngle = ArcusArcMath.radians(endDegrees)
        }
    }

    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            adjustedRadius = radius - (controlWidth / 2)
        }
    }

    @IBInspectable var controlWidth: CGFloat = 25 {
        didSet {
            adjustedRadius = radius - (controlWidth / 2)
            arcView.width = controlWidth
            handleView.width = controlWidth
            setNeedsDisplay()
        }
    }

    @IBInspectable var centerPoint: CGPoint = CGPoint() {
        didSet {
            arcView.centerPoint = centerPoint
            handleView.centerPoint = centerPoint

            setNeedsDisplay()
        }
    }

    @IBInspectable var hueBased: Bool = false {
        didSet {
          if hueBased {
            if let mode = ArcMode(rawValue: 1) {
              arcView.arcMode = mode
            }
          } else {
            if let mode = ArcMode(rawValue: 0) {
              arcView.arcMode = mode
            }

          }
        }
    }

    @IBInspectable var hueRangeStart: Double = 0 {
        didSet {
            arcView.hueRangeStart = hueRangeStart
            setNeedsDisplay()
        }
    }

    @IBInspectable var hueRangeEnd: Double = 360 {
        didSet {
            arcView.hueRangeEnd = hueRangeEnd
            setNeedsDisplay()
        }
    }

    @IBInspectable var color1: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color2: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color3: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color4: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color5: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color6: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color7: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color8: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color9: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var color10: UIColor! {
        didSet {
            configureColorsArray()
        }
    }
    @IBInspectable var handleColor: UIColor! {
        didSet {
            handleView.color = handleColor
        }
    }
    @IBInspectable var handleShadowColor: UIColor! {
        didSet {
            handleView.shadowColor = handleShadowColor
        }
    }

    var adjustedStartAngle: CGFloat = 0 {
        didSet {
            arcView.startAngle = adjustedStartAngle
            activeAngle = adjustedStartAngle
            setNeedsDisplay()
        }
    }
    var adjustedEndAngle: CGFloat = 0 {
        didSet {
            arcView.endAngle = adjustedEndAngle
            setNeedsDisplay()
        }
    }
    var adjustedRadius: CGFloat = 0 {
        didSet {
            arcView.radius = adjustedRadius
            handleView.radius = adjustedRadius
            setNeedsDisplay()
        }
    }

    var activeAngle: CGFloat = -1 {
        didSet {
            handleView.currentAngle = activeAngle
            currentControlPoint = ArcusArcMath.pointForAngle(activeAngle,
                                                                 center: centerPoint,
                                                                 radius: adjustedRadius)
            setNeedsDisplay()
        }
    }
    var activeStartAngle: CGFloat = 0

    fileprivate var currentControlPoint: CGPoint = CGPoint() {
        didSet {
            if hueBased == false {
                if arcView != nil {
                    let color: UIColor = arcView.getColorFromPoint(currentControlPoint)
                    if color.rgba() != UIColor.clear.rgba() {
                        selectedColor = color
                    }
                }
            } else {
                let hue: Double = round(currentValue * 360)
                selectedColor = UIColor(hue: CGFloat(hue / 360),
                                             saturation: 0.75,
                                             brightness: 1.0,
                                             alpha: 1.0)
            }
        }
    }

    var colorsArray: [UIColor] = [] {
        didSet {
            arcView.colorsArray = colorsArray
            setNeedsDisplay()
        }
    }

    // MARK: View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        initLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initLayers()
    }

    func initLayers() {
        arcView = ArcusArcView(frame: bounds)
        handleView = ArcusArcHandleView(frame: bounds)

        arcView.backgroundColor = UIColor.clear
        handleView.backgroundColor = UIColor.clear

        arcView.colorsArray = colorsArray

        arcView.arcMode = ArcMode.hueBased
        arcView.hueRangeStart = 14.55
        arcView.hueRangeEnd = 343.5

        layer.addSublayer(arcView.layer)
        layer.addSublayer(handleView.layer)
    }

    override func setNeedsDisplay() {
        super.setNeedsDisplay()

        if arcView != nil {
            arcView.setNeedsDisplay()
        }

        if handleView != nil {
            handleView.setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        arcView.frame = bounds
        handleView.frame = bounds

        super.layoutSubviews()
    }

    // MARK: Public Configuration Methods
    func setHandlePostitionForColor(_ color: UIColor) -> Bool {
        if hueBased == false {
            let resultDegree = degreeForColor(color,
                                                   center: centerPoint,
                                                   radius: adjustedRadius,
                                                   startAngle: adjustedStartAngle,
                                                   endAngle: adjustedEndAngle,
                                                   colorsArray: colorsArray)

//            print("Result Degree: \(resultDegree)")

            return setHandlePositionToDegree(resultDegree)
        } else {
            let hsba = color.hsba()
            let resultDegree = ArcusArcMath.degreeForHue(Double(hsba.hue),
                                                        startDegree: startDegrees,
                                                        endDegree: endDegrees,
                                                        hueStartLimit: hueRangeStart,
                                                        hueEndLimit: hueRangeEnd)

//            print("Result Degree: \(resultDegree)")

            return setHandlePositionToDegree(resultDegree)

        }
    }

    func setHandlePositionToValue(_ value: Double) -> Bool {
        var difference: Double = abs(endDegrees - startDegrees)
        if startDegrees > endDegrees {
            difference = (360 - startDegrees) + endDegrees
        }

        let degree: Double = (startDegrees + (value * difference) + 360)
          .truncatingRemainder(dividingBy: 360)
        return setHandlePositionToDegree(degree)
    }

    func setHandlePositionToDegree(_ degree: Double) -> Bool {
        var moveHandle: Bool = false

        if startDegrees > endDegrees {
            if degree >= endDegrees && endDegrees <= 360 {
                moveHandle = true
            } else if degree <= endDegrees && degree >= 0 {
                moveHandle = true
            }
        } else {
            if degree <= endDegrees && degree >= startDegrees {
                moveHandle = true
            }
        }

        if moveHandle {
            activeAngle = ArcusArcMath.radians(degree)
        } else {
            activeAngle = adjustedStartAngle
        }

        return moveHandle
    }

    // MARK: Private Methods
    func  configureColorsArray() {
        var array: [UIColor] = []

        if color1 != nil {
            array.append(color1)
        }

        if color2 != nil {
            array.append(color2)
        }

        if color3 != nil {
            array.append(color3)
        }

        if color4 != nil {
            array.append(color4)
        }

        if color5 != nil {
            array.append(color5)
        }

        if color6 != nil {
            array.append(color6)
        }

        if color7 != nil {
            array.append(color7)
        }

        if color8 != nil {
            array.append(color8)
        }

        if color9 != nil {
            array.append(color9)
        }

        if color10 != nil {
            array.append(color10)
        }

        if array.count == 0 {
            array.append(UIColor.lightGray)
        }
        colorsArray = array
    }

    func degreeForColor(_ color: UIColor,
                        center: CGPoint,
                        radius: CGFloat,
                        startAngle: CGFloat,
                        endAngle: CGFloat,
                        colorsArray: [UIColor]) -> Double {
        var resultDegree: Double = -1

        let startDegree: Int = Int(ArcusArcMath.degrees(startAngle))
        let endDegree: Int = Int(ArcusArcMath.degrees(endAngle))

        var difference: Int = abs(endDegree - startDegree)
        if startDegree > endDegree {
            difference = (360 - startDegree) + endDegree
        }

        let paddedDifference = difference * 2
        let colorCount: Int = colorsArray.count
        let colorStep: Int = paddedDifference / (colorCount - 1)
        var currentStep: Int = -1
        var nextStep: Int = 0

        for i in 0..<(paddedDifference) {
            if i % colorStep == 0 {
                currentStep += 1
                nextStep += 1
            }

            if currentStep >= 0 && nextStep < colorCount {
                let indexDegree: Double = ((Double(i) / 2) + Double(startDegree))
                  .truncatingRemainder(dividingBy: 360)
                let percent: Double =
                    Double(i - (currentStep * colorStep)) / Double(colorStep)
                let startColor: UIColor = colorsArray[currentStep]
                let endColor: UIColor = colorsArray[nextStep]
                let newColor: UIColor = UIColor.interpolatedColor(percent,
                                                                  startColor: startColor,
                                                                  endColor: endColor)

                if newColor.compareHSB(color, tolerance: 0.20) == true {
                    resultDegree = indexDegree
                    break
                }
            }
        }

        return floor(resultDegree)
    }

    // MARK: Touch Handling
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)

        activeStartAngle = activeAngle

        let touchPoint: CGPoint = touch.location(in: self)
        moveHandle(touchPoint)

        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)

        let touchPoint: CGPoint = touch.location(in: self)
        moveHandle(touchPoint)

        return true

    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)

        activeAngle = activeStartAngle
    }

    func moveHandle(_ point: CGPoint) {
        let newAngle: CGFloat = ArcusArcMath.angleForPoint(point,
                                                          center: centerPoint)
        let newDegree: Double = ((round(ArcusArcMath.degrees(newAngle)) + 360)
          .truncatingRemainder(dividingBy: 360))

        let start: Double = ((startDegrees - 2) + 360).truncatingRemainder(dividingBy: 360)
        let end: Double =  ((endDegrees + 2) + 360).truncatingRemainder(dividingBy: 360)

        var changeValues: Bool = false
        var difference: Double = abs(end - start)
        var currentValue: Double = 0.0
        if start > end {
            difference = (360 - start) + end
            if newDegree >= start && start <= 360 {
                currentValue = round(((newDegree - start) / difference) * 100) / 100
                changeValues = true
            } else if newDegree <= end && newDegree >= 0 {
                currentValue = round((((360 - start) + newDegree) / difference) * 100) / 100
                changeValues = true
            }
        } else if newDegree <= end && newDegree >= start {
            currentValue = round(((newDegree - start) / difference) * 100) / 100
            changeValues = true
        }

        if changeValues == true {
            self.activeAngle = newAngle
            self.currentValue = currentValue

            sendActions(for: UIControlEvents.valueChanged)
        }
    }
}
