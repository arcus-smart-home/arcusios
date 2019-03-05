//
//  ArcusColorSelectionTarget.swift
//  i2app
//
//  Created by Arcus Team on 6/28/16.
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

protocol ArcusColorSliderTarget {
    func colorSliderColorValueChanged(_ oldColor: UIColor, newColor: UIColor) -> UIColor
    func saturationSliderColorValueChanged(_ oldColor: UIColor, newColor: UIColor) -> UIColor
    func saturationRangeColorsForColor(_ color: UIColor) -> [UIColor]
    func colorTemperatureValueChanged(_ value: Double, min: Double, max: Double) -> Double
}

extension ArcusColorSliderTarget {
    func colorSliderColorValueChanged(_ oldColor: UIColor, newColor: UIColor) -> UIColor {
        let old = oldColor.hsba()
        let new = newColor.hsba()

        return UIColor(hue: new.hue,
                       saturation: old.saturation,
                       brightness: new.brightness,
                       alpha: new.alpha)
    }

    func saturationSliderColorValueChanged(_ oldColor: UIColor,
                                           newColor: UIColor) -> UIColor {
        let old = oldColor.hsba()
        let new = newColor.hsba()

        return UIColor(hue: old.hue,
                       saturation: new.saturation,
                       brightness: old.brightness,
                       alpha: old.alpha)

    }

    func saturationRangeColorsForColor(_ color: UIColor) -> [UIColor] {
        let hsba = color.hsba()

        let startColor: UIColor = UIColor(hue: hsba.hue,
                                          saturation: 0,
                                          brightness: hsba.brightness,
                                          alpha: hsba.alpha)
        let endColor: UIColor = UIColor(hue: hsba.hue,
                                        saturation: 1,
                                        brightness: hsba.brightness,
                                        alpha: hsba.alpha)
        return [startColor, endColor]
    }

    func colorTemperatureValueChanged(_ value: Double, min: Double, max: Double) -> Double {
        let difference: Double = max - min
//        return (round((value * difference) * 10) / 10) + min
        return (value * difference) + min
    }
}
