//
//  ArcusColorSelectionViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/20/16.
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
import Cornea
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

@objc enum ColorSelectionType: Int {
  case color = 0
  case temperature = 1
  case normal = 2
}

@objc protocol ArcusColorSelectionDelegate {
  func didSelectColor(_ color: UIColor,
                      hue: Double,
                      saturation: Double,
                      brightness: Double,
                      alpha: Double,
                      sender: ArcusNormalColorTempSelectionViewController)
  @objc optional func didChangeColorSelectionType(_ selectionType: ColorSelectionType,
                                                  sender: ArcusNormalColorTempSelectionViewController)
  @objc optional func didSelectColorTemperature(_ color: UIColor,
                                                temperature: Double,
                                                sender: ArcusNormalColorTempSelectionViewController)
  @objc optional func didDismiss(_ sender: ArcusNormalColorTempSelectionViewController)
}

@objc class ArcusNormalColorTempSelectionViewController: UIViewController, ArcusColorSliderTarget {
  @IBOutlet var doneButton: ArcusButton!
  @IBOutlet var colorButton: ArcusButton?
  @IBOutlet var temperatureButton: ArcusButton?
  @IBOutlet var normalButton: ArcusButton?
  @IBOutlet var colorSlider: ArcusArcSlider?
  @IBOutlet var saturationSlider: ArcusArcSlider?
  @IBOutlet var colorDisplayView: UIView?
  @IBOutlet var temperatureSlider: ArcusArcSlider?
  @IBOutlet var colorValuesView: RGBLabelsView?
  @IBOutlet var tempurateValuesView: ColorTemperatureLabelsView?
  @IBOutlet var hueLabel: ArcusLabel?
  @IBOutlet var intensityLabel: ArcusLabel?
  @IBOutlet weak var slidersView: UIView!
  @IBOutlet weak var normalLightBulbView: UIView!

  internal weak var delegate: ArcusColorSelectionDelegate?
  internal var completion: ((UIColor, Double?) -> Void)?
  internal var colorTemperatureMin: Double = 2000
  internal var colorTemperatureMax: Double = 8000
  internal var currentTemperature: Double = 2000 {
    didSet {
      self.updateColorDisplayView()
      self.updateLabels()
    }
  }

  internal var selectionType: ColorSelectionType = .color {
    didSet {
      self.updateButtonState()
      self.updateSliderPositions()
      self.updateSliderState()
      self.updateColorDisplayView()
      self.updateLabelViews()
      self.updateLabels()

      self.delegate?.didChangeColorSelectionType?(self.selectionType, sender: self)
    }
  }

  var currentColor: UIColor = UIColor.white {
    didSet {
      self.updateColorDisplayView()
      self.updateLabels()
    }
  }

  var currentTemperatureColor: UIColor = UIColor.white

  // MARK: View LifeCycle
  class func create() -> ArcusNormalColorTempSelectionViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "ColorSelection", bundle:nil)
    let viewController: ArcusNormalColorTempSelectionViewController? =
      storyboard.instantiateViewController(withIdentifier:
        String(describing: ArcusNormalColorTempSelectionViewController.self))
        as? ArcusNormalColorTempSelectionViewController

    return viewController!
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.configureBeginningState()
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: UIConfiguration
  func configureColorDisplayView() {
    if let colorDisplayView = self.colorDisplayView {
      let cornerRadius = colorDisplayView.frame.size.height / 2
      self.colorDisplayView?.layer.cornerRadius = cornerRadius
    }
    self.colorDisplayView?.layer.borderWidth = 0.0
    self.colorDisplayView?.clipsToBounds = true
  }

  func configureBeginningState() {
    // Configure Sliders
    self.updateSliderPositions()
    self.updateSliderState()

    // Configure & Set Color Display View
    self.configureColorDisplayView()
    self.updateColorDisplayView()

    // Configure Buttons
    self.updateButtonState()

    // Configure Labels Views
    self.updateLabelViews()
    self.updateLabels()

  }

  func updateLabelViews() {
    self.colorValuesView?.isHidden = self.selectionType != .color
    self.tempurateValuesView?.isHidden = self.selectionType != .temperature
  }

  func updateLabels() {
    if self.selectionType == .color {
      let hsba = self.currentColor.hsba()
      let rgbColor = UIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: 1.0, alpha: 1.0)
      let currentRGBA = rgbColor.rgba()
      let red: Int = Int(floor(currentRGBA.red))
      let green: Int = Int(floor(currentRGBA.green))
      let blue: Int = Int(floor(currentRGBA.blue))
      
      self.colorValuesView?.updateRGBLabels(red, green: green, blue: blue)
    } else if self.selectionType == .temperature {
      self.tempurateValuesView?.updateTemperateLabel(Int(self.currentTemperature))
    }
  }

  func updateButtonState() {

    if self.selectionType == .color {
      self.colorButton?.borderWidth = 1
    } else {
      self.colorButton?.borderWidth = 0
    }

    if self.selectionType == .temperature {
      self.temperatureButton?.borderWidth = 1
    } else {
      self.temperatureButton?.borderWidth = 0
    }

    if self.selectionType == .normal {
      self.normalButton?.borderWidth = 1
    } else {
      self.normalButton?.borderWidth = 0
    }
  }

  func updateSliderState() {
    self.hueLabel?.isHidden = self.selectionType != .color
    self.intensityLabel?.isHidden = self.selectionType != .color
    self.colorSlider?.isHidden = self.selectionType != .color
    self.saturationSlider?.isHidden = self.selectionType != .color
    self.temperatureSlider?.isHidden = self.selectionType != .temperature
    self.colorDisplayView?.isHidden = self.selectionType == .normal
    self.normalLightBulbView?.isHidden = self.selectionType != .normal
  }

  func updateSliderPositions() {
    if self.selectionType == .color {
      let hsba = self.currentColor.hsba()

      let startDegree: Double? = self.colorSlider?.startDegrees
      let endDegree: Double? = self.colorSlider?.endDegrees

      if startDegree != nil && endDegree != nil {
        let hueStart: Double? = self.colorSlider?.hueRangeStart
        let hueEnd: Double? = self.colorSlider?.hueRangeEnd
        let colorDegree: Double = ArcusArcMath.degreeForHue(Double(hsba.hue),
                                                           startDegree: startDegree!,
                                                           endDegree: endDegree!,
                                                           hueStartLimit: hueStart!,
                                                           hueEndLimit: hueEnd!)

        if self.colorSlider?.setHandlePositionToDegree(colorDegree) == false {
        }
      }

      self.saturationSlider?.colorsArray =
        self.saturationRangeColorsForColor(self.currentColor)

      if self.saturationSlider?.setHandlePositionToValue(Double(hsba.saturation)) == false {

      }
    } else if self.selectionType == .temperature {
      let startColor: UIColor = UIColor.colorWithKelvin(CGFloat(self.colorTemperatureMin))
      let endColor: UIColor = UIColor.colorWithKelvin(CGFloat(self.colorTemperatureMax))

      let difference: Double = self.colorTemperatureMax - self.colorTemperatureMin
      let differenceHalf: Double = difference / 2
      let differenceQtr: Double = differenceHalf / 2

      let firstQtrValue: Double = differenceQtr + self.colorTemperatureMin
      let midValue: Double = differenceHalf + self.colorTemperatureMin
      let thirdQtrValue: Double = differenceHalf + differenceQtr + self.colorTemperatureMin

      let firstQtrColor: UIColor = UIColor.colorWithKelvin(CGFloat(firstQtrValue))
      let midColor: UIColor = UIColor.colorWithKelvin(CGFloat(midValue))
      let thirdQtrColor: UIColor = UIColor.colorWithKelvin(CGFloat(thirdQtrValue))

      self.temperatureSlider?.colorsArray = [startColor,
                                             firstQtrColor,
                                             midColor,
                                             thirdQtrColor,
                                             endColor]

      let currentPosition: Double = (self.currentTemperature - self.colorTemperatureMin)
        / difference
      _ = self.temperatureSlider?.setHandlePositionToValue(currentPosition)
      if let color: UIColor? = self.temperatureSlider?.selectedColor {
        self.currentTemperatureColor = color!
      }
    }
  }

  func valueForSaturation(_ saturation: Double) -> Double {
    let startDegree: Double? = self.colorSlider?.startDegrees
    let endDegree: Double? = self.colorSlider?.endDegrees
    var value: Double = 0

    if startDegree != nil && endDegree != nil {
      var difference: Double = abs(endDegree! - startDegree!)
      if startDegree > endDegree {
        difference = (360 - startDegree!) + endDegree!
      }

      value = saturation * difference
    }

    return value
  }

  func updateColorDisplayView() {
    if self.selectionType == .color {
      self.colorDisplayView?.backgroundColor = self.currentColor
    } else if self.selectionType == .temperature {
      self.colorDisplayView?.backgroundColor = self.currentTemperatureColor
    }
  }

  // MARK: IBActions
  @IBAction func colorSliderDidChange(_ sender: ArcusArcSlider) {
    if sender == self.colorSlider {
      self.currentColor =
        colorSliderColorValueChanged(self.currentColor,
                                     newColor: sender.selectedColor)
      self.saturationSlider?.colorsArray = saturationRangeColorsForColor(self.currentColor)
    }
  }

  @IBAction func sliderDidChangeEnded(_ sender: ArcusArcSlider) {
    self.communicateColorChangeToDelegate()
  }

  @IBAction func saturationSliderDidChange(_ sender: ArcusArcSlider) {
    if sender == self.saturationSlider {
      self.currentColor =
        saturationSliderColorValueChanged(self.currentColor,
                                          newColor: sender.selectedColor)
    }
  }

  @IBAction func temperatureSliderDidChange(_ sender: ArcusArcSlider) {
    if sender == self.temperatureSlider {
      self.currentTemperatureColor = sender.selectedColor
      self.currentTemperature =
        self.colorTemperatureValueChanged(sender.currentValue,
                                          min: self.colorTemperatureMin,
                                          max: self.colorTemperatureMax)
    }
  }

  @IBAction func normalButtonPressed(_ sender: ArcusButton) {
    if sender == self.normalButton {
      self.selectionType = .normal
    }
  }

  @IBAction func colorButtonPressed(_ sender: ArcusButton) {
    if sender == self.colorButton {
      self.selectionType = .color
    }
  }

  @IBAction func temperatureButtonPressed(_ sender: ArcusButton) {
    if sender == self.temperatureButton {
      self.selectionType = .temperature
    }
  }

  @IBAction func doneButtonPressed(_ sender: ArcusButton) {
    self.dismiss(animated: true) {
      self.delegate?.didDismiss?(self)
    }
  }

  func communicateColorChangeToDelegate() {
    if self.delegate != nil {
      if self.selectionType == .color {
        let hsba = self.currentColor.hsba()
        self.delegate?.didSelectColor(self.currentColor,
                                      hue: Double(hsba.hue),
                                      saturation: Double(hsba.saturation),
                                      brightness: Double(hsba.brightness),
                                      alpha: Double(hsba.alpha),
                                      sender: self)
      } else if self.selectionType == .temperature {
        self.delegate?.didSelectColorTemperature?(self.currentTemperatureColor,
                                                  temperature: self.currentTemperature,
                                                  sender: self)
      }
    } else if self.completion != nil {
      var color: UIColor = self.currentTemperatureColor
      if self.selectionType == .color {
        color = self.currentColor
      }
      var temp: Double? = nil
      if self.selectionType != .color {
        temp = self.currentTemperature
      }

      self.completion?(color, temp)
    }
  }
}
