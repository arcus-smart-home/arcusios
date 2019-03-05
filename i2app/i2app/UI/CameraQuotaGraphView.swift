//
//  CameraQuotaGraphView.swift
//  i2app
//
//  Created by Arcus Team on 8/23/17.
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

import Foundation
import Cornea

@IBDesignable class CameraQuotaGraphView: UIView {
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
      setNeedsDisplay()
    }
  }

  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
      setNeedsDisplay()
    }
  }

  @IBInspectable var borderColor: UIColor = UIColor.white {
    didSet {
      if layer.borderWidth > 0 {
        layer.borderColor = borderColor.cgColor
      }
      setNeedsDisplay()
    }
  }

  @IBInspectable var barColor: UIColor = UIColor.white {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var barValue: CGFloat = 0.5 {
    didSet {
      setNeedsDisplay()
    }
  }

  // MARK: Drawing

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    drawBarGraph()
  }

  func drawBarGraph() {
    let width = bounds.width * barValue
    let height = bounds.height

    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    let path = UIBezierPath(rect: rect)

    barColor.set()

    path.stroke()
    path.fill()
  }
}
