//
//  GradientColorable.swift
//  i2app
//
//  Created by Arcus Team on 8/3/17.
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

/**
 Common preset values to ensure consistency among gradients in the app.
 */
enum GradientPresetColors {
  static let pinkLight = UIColor(red: 211/255.0, green: 0/255.0, blue: 75/255.0, alpha: 1.0)
  static let pinkDark = UIColor(red: 136/255.0, green: 0/255.0, blue: 96/255.0, alpha: 1.0)
}

/**
 Mixin to create and manage gradient creation and coloring.
 */
protocol GradientColorable {

  // MARK: Extended

  /**
   This function adds a gradient layer to the given view with the colors provided. This should only be used
   for background layers as it inserts the gradient layer at position 0 in the sublayers array. The frame of
   the created gradient layer will be equals to the bounds of the given view.

   - Parameters:
   - view: The view to have the background gradient added to.
   - topColor: The color to be used at the higher portion of the gradient.
   - bottomColor: The color to be used at the lower portion of the gradient.
   */
  func addBackgroundGradient(inView view: UIView, topColor: UIColor, bottomColor: UIColor)
}

extension GradientColorable {
  func addBackgroundGradient(inView view: UIView, topColor: UIColor, bottomColor: UIColor) {
    var gradientLayer: CAGradientLayer

    if let layer = view.layer.sublayers?.first as? CAGradientLayer {
      gradientLayer = layer
    } else {
      gradientLayer = CAGradientLayer()
    }

    let top = topColor.cgColor as CGColor
    let bottom = bottomColor.cgColor as CGColor

    gradientLayer.frame = view.bounds
    gradientLayer.colors = [top, bottom]
    gradientLayer.locations = [0.0, 1.0]

    view.layer.insertSublayer(gradientLayer, at: 0)
  }
}

