//
//  UIView+Extension.swift
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

extension UIView {
  func getColorFromPoint(_ point: CGPoint) -> UIColor {
    let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

    var pixelData: [UInt8] = [0, 0, 0, 0]

    let context = CGContext(data: &pixelData,
                            width: 1,
                            height: 1,
                            bitsPerComponent: 8,
                            bytesPerRow: 4,
                            space: colorSpace,
                            bitmapInfo: bitmapInfo.rawValue)
    context?.translateBy(x: -point.x, y: -point.y)
    self.layer.render(in: context!)

    let red: CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
    let green: CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
    let blue: CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
    let alpha: CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
}
