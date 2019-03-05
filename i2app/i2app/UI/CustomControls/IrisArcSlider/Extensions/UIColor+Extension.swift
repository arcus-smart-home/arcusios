//
//  UIColor+Extension.swift
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

typealias HSBATuple = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
typealias HSBADoubleTuple = (hue: Double, saturation: Double, brightness: Double, alpha: Double)
typealias RGBATuple = (red: Double, green: Double, blue: Double, alpha: Double)

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(red: CGFloat(red) / 255.0,
              green: CGFloat(green) / 255.0,
              blue: CGFloat(blue) / 255.0,
              alpha: 1.0)
  }

  convenience init(hex: String, alpha: CGFloat = 1) {
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 0

    var rgbValue: UInt64 = 0

    scanner.scanHexInt64(&rgbValue)

    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff

    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff,
      alpha: alpha
    )
  }

  convenience init(netHex: Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }

  func rgba() -> RGBATuple {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    self.getRed(&red,
                green: &green,
                blue: &blue,
                alpha: &alpha)

    red = round((red * 255.0 * 100)) / 100
    green = round((green * 255.0 * 100)) / 100
    blue = round((blue * 255.0 * 100)) / 100
    alpha *= 255.0

    let redNum = NSNumber(value: Float(red))
    let greenNum = NSNumber(value: Float(green))
    let blueNum = NSNumber(value: Float(blue))
    let alphaNum = NSNumber(value: Float(alpha))

    return (red: redNum.doubleValue,
            green: greenNum.doubleValue,
            blue: blueNum.doubleValue,
            alpha: alphaNum.doubleValue)
  }

  func hsba() -> HSBATuple {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    self.getHue(&hue,
                saturation: &saturation,
                brightness: &brightness,
                alpha: &alpha)

    return (hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: alpha)
  }

  func hsbaDouble() -> HSBADoubleTuple {
    let tuple: HSBATuple = hsba()

    let hueNum = NSNumber(value: Float(tuple.hue))
    let satNum = NSNumber(value: Float(tuple.saturation))
    let brightNum = NSNumber(value: Float(tuple.brightness))
    let alphaNum = NSNumber(value: Float(tuple.alpha))

    return (hue: hueNum.doubleValue,
            saturation: satNum.doubleValue,
            brightness: brightNum.doubleValue,
            alpha: alphaNum.doubleValue)
  }

  @objc class func colorWithKelvin(_ kelvin: CGFloat) -> UIColor {
    if (kelvin < 1000) || (kelvin > 40000) {
      print("Warning: temperature should range between 1000 and 40000")
    }
    let temperature: CGFloat = kelvin / 100
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat

    if temperature <= 66 {
      red = 0xFF
      green = temperature
      green = 99.4708025861 * log(green) - 161.1195681661
    } else {
      red = temperature - 60
      red = 329.698727446 * pow(red, -0.1332047592)
      green = temperature - 60
      green = 288.1221695283 * pow(green, -0.0755148492)
    }

    if temperature >= 66 {
      blue = 0xFF
    } else if temperature <= 19 {
      blue = 0
    } else {
      blue = temperature-10
      blue = 138.5177312231 * log(blue) - 305.0447927307

    }

    red = max(red, 0)
    red = min(red, 0xFF)
    green = max(green, 0)
    green = min(green, 0xFF)
    blue = max(blue, 0)
    blue = min(blue, 0xFF)

    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
  }

  static func interpolatedColor(_ percent: Double, startColor: UIColor, endColor: UIColor) -> UIColor {
    let startRGB = startColor.rgba()
    let endRGB = endColor.rgba()

    let redValue = CGFloat(startRGB.red + percent * (endRGB.red - startRGB.red))
    let red: CGFloat = redValue / 255.0

    let greenValue = CGFloat(startRGB.green + percent * (endRGB.green - startRGB.green))
    let green: CGFloat = greenValue / 255.0

    let blueValue = CGFloat(startRGB.blue + percent * (endRGB.blue - startRGB.blue))
    let blue: CGFloat = blueValue / 255.0

    let alphaValue = CGFloat(startRGB.alpha + percent * (endRGB.alpha - startRGB.alpha))
    let alpha: CGFloat = alphaValue / 255.0

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  func compareRGB(_ color: UIColor, tolerance: Double) -> Bool {
    let RGBA = self.rgba()
    let compareRGBA = color.rgba()

    //        print("RGBA        \(RGBA)")
    //        print("compareRGBA \(compareRGBA)")

    let toleranceValue: Double = (255 * tolerance)

    var redMinValue: Double = 0
    if RGBA.red - toleranceValue > 0 {
      redMinValue = RGBA.red - toleranceValue
    }

    var redMaxValue: Double = 255
    if RGBA.red + toleranceValue < 255 {
      redMaxValue = RGBA.red + toleranceValue
    }

    let redResult: Bool = (compareRGBA.red >= redMinValue) &&
      (compareRGBA.red <= redMaxValue)

    var greenMinValue: Double = 0
    if RGBA.green - toleranceValue > 0 {
      greenMinValue = RGBA.green - toleranceValue
    }

    var greenMaxValue: Double = 255
    if RGBA.green + toleranceValue < 255 {
      greenMaxValue = RGBA.green + toleranceValue
    }

    let greenResult: Bool = (compareRGBA.green >= greenMinValue) &&
      (compareRGBA.green <= greenMaxValue)

    var blueMinValue: Double = 0
    if RGBA.blue - toleranceValue > 0 {
      blueMinValue = RGBA.blue - toleranceValue
    }

    var blueMaxValue: Double = 255
    if RGBA.blue + toleranceValue < 255 {
      blueMaxValue = RGBA.blue + toleranceValue
    }

    let blueResult: Bool = (compareRGBA.blue >= blueMinValue) &&
      (compareRGBA.blue <= blueMaxValue)

    //        print("redResult: \(redResult) greenResult: \(greenResult) blueResult: \(blueResult)")

    return redResult && greenResult && blueResult
  }

  func compareHSB(_ color: UIColor, tolerance: Double) -> Bool {
    let hsba: HSBADoubleTuple = self.hsbaDouble()
    let hue: Double = hsba.hue * 360
    let saturation: Double = hsba.saturation * 100
    let brightness: Double = hsba.brightness * 100

    let compareHsba: HSBADoubleTuple = color.hsbaDouble()
    let cHue: Double = compareHsba.hue * 360
    let cSaturation: Double = compareHsba.saturation * 100
    let cBrightness: Double = compareHsba.brightness * 100

    //        print("HSBA        \(HSBA)")
    //        print("compareHSBA \(compareHSBA)")

    let hueTolerance: Double = (360 * tolerance)
    let toleranceValue: Double = (100 * tolerance)

    var hueMinValue: Double = 0
    if hue - hueTolerance > 0 {
      hueMinValue = hue - hueTolerance
    }
    var satMinValue: Double = 0
    if saturation - toleranceValue > 0 {
      satMinValue = saturation - toleranceValue
    }
    var brightMinValue: Double = 0
    if brightness - toleranceValue > 0 {
      brightMinValue = brightness - toleranceValue
    }

    var hueMaxValue: Double = 360
    if hue + hueTolerance < 360 {
      hueMaxValue = hue + hueTolerance
    }
    var satMaxValue: Double = 100
    if saturation + toleranceValue < 100 {
      satMaxValue = saturation + toleranceValue
    }
    var brightMaxValue: Double = 100
    if brightness + toleranceValue < 100 {
      brightMaxValue = brightness + toleranceValue
    }

    let hueResult: Bool = (cHue >= hueMinValue) &&
      (cHue <= hueMaxValue)
    let satResult: Bool = (cSaturation >= satMinValue) &&
      (cSaturation <= satMaxValue)
    let brightResult: Bool = (cBrightness >= brightMinValue) &&
      (cBrightness <= brightMaxValue)

    //        print("hueResult: \(hueResult) satResult: \(satResult) brightResult: \(brightResult)")
    //        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

    return hueResult && satResult && brightResult
  }
}
