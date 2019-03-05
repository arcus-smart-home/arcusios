//
//  RadialAnimationView.swift
//  i2app
//
//  Created by Arcus Team on 8/6/18.
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

@IBDesignable
class RadialAnimationView: UIView {
  
  @IBInspectable var imageName: String = "" {
    didSet {
      updateView()
    }
  }
  
  @IBInspectable var isAnimating: Bool = false {
    didSet {
      isAnimating ? startAnimation() : stopAnimation()
    }
  }
  
  private let animationsWithDelayStartIndex = 2
  private var startAnimationDelay: Double = 0.5
  private var delayIncrement: Double = 0.5
  private var animationDuration: Double = 2.0
  private var startScale: Double = 1.0
  private var endScale: Double = 1.5
  private let circleCount = 4
  private var circleColor: CGColor = ScleraColor.purple.cgColor
  private var mainImage: UIImage?
  private var imageLayer: CALayer!
  
  // MARK: Animation Keys
  fileprivate let scaleKey = "transform.scale"
  fileprivate let opacityKey = "opacity"
  fileprivate let kAnimationKey = "opacity"
  
  // MARK: UIVIew Functions
  
  /// - Parameter aDecoder: An unarchiver object.
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    updateView()
  }
  
  /// - Parameter frame: An CGRect for frame size
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    updateView()
  }
  
  /// Shared setup logic for both initializers
  private func updateView() {
    self.backgroundColor = UIColor.clear
    
    mainImage = UIImage(named: imageName)
   
    if let image = mainImage {
      let imageLayer = CALayer()
      let dx = (self.frame.size.width - image.size.width) / 2.0
      let dy = (self.frame.size.height - image.size.height) / 2.0
      let centerPoint = CGPoint(x: dx, y: dy)
      imageLayer.frame = CGRect(origin: centerPoint, size: image.size)
      imageLayer.contents = image.cgImage
      self.imageLayer = imageLayer
    }
  }
  
  // MARK: Animation Functions
  
  /// Start the Pairing Animation
  func startAnimation() {
    // Clear existing circles before adding new ones
    stopAnimation()
    
    setupCircles()
    imageLayer.removeFromSuperlayer()
    layer.addSublayer(imageLayer)
  }
  
  /// Stops the Pairing View's Animation immediately
  func stopAnimation() {
    layer.sublayers?.forEach({ layer in
      if let _ = layer.animation(forKey: kAnimationKey) {
        layer.removeAnimation(forKey: kAnimationKey)
        layer.removeFromSuperlayer()
      }
    })
  }
  
  // MARK: Helper functions
  
  /// Sets up the specific number of disc and starts their animations
  private func setupCircles() {
    imageLayer.removeFromSuperlayer()
    
    if let image = mainImage {
      for idx in 0 ..< circleCount {
        let dx = self.frame.size.width  / 2.0
        let dy = self.frame.size.height / 2.0
        let centerPoint = CGPoint(x: dx, y: dy)
        let circleShape = diskLayer(radius: image.size.width / 2.0,
                                    origin: centerPoint,
                                    color: circleColor)
        layer.insertSublayer(circleShape, at: 0)
        let animation = animationWithIndex(index: idx, total: circleCount - 1)
        circleShape.add(animation, forKey: kAnimationKey)
      }
    }
    
    layer.addSublayer(imageLayer)
  }
  
  /// Creates an Animation for a disc
  ///
  /// - Parameters:
  ///   - index: the current index that should be animated
  ///   - total: the total number of objects to animate
  /// - Returns: an Animation that can be added to a CALayer to do our animation with timing
  private func animationWithIndex(index idx: Int, total: Int) -> CAAnimation {
    
    let offsetByIdx = Double(idx) * delayIncrement
    let offsetByTotal = Double(total) * delayIncrement
    
    let scale = CABasicAnimation(keyPath: scaleKey)
    scale.fromValue = startScale
    scale.toValue = endScale
    scale.fillMode = kCAFillModeForwards
    scale.duration = animationDuration
    
    let opacityAnimation = CABasicAnimation(keyPath: opacityKey)
    opacityAnimation.fromValue = 0.6
    opacityAnimation.toValue = 0.0
    opacityAnimation.fillMode = kCAFillModeForwards
    opacityAnimation.duration = animationDuration
    
    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [scale, opacityAnimation]
    animationGroup.beginTime = CACurrentMediaTime() + offsetByIdx
    animationGroup.duration = animationDuration + offsetByTotal
    animationGroup.repeatCount = Float.greatestFiniteMagnitude
    
    return animationGroup
  }
  
  /// Creates a disk layer
  ///
  /// - Parameters:
  ///   - radius: the radius of the disk
  ///   - origin: the origin of the disk
  ///   - color: the color of the disk
  /// - Returns: a disk layer
  private func diskLayer(radius: CGFloat,
                         origin: CGPoint,
                         color: CGColor) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
    layer.position = origin
    let center = CGPoint(x: radius, y: radius)
    let path = UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: 0,
                            endAngle: 2 * .pi,
                            clockwise: true)
    layer.path = path.cgPath
    layer.fillColor = color
    return layer
  }
}
