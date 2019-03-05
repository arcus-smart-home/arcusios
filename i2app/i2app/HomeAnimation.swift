//
//  HomeAnimation.swift
//  PairingAnimationView
//
//  Created by Arcus Team on 4/5/18.
//
//  Most of the Development Work for this animation what originally done by Erik Anderson
//  using Kotlin, this file was created to be an iOS counterpart to his work.
//
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

@IBDesignable
class HomeAnimationView: UIView {

  private let animationsWithDelayStartIndex = 2
  private var startAnimationDelay: Double = 0.5
  private var delayIncrement: Double = 0.5
  private var animationDuration: Double = 4.0
  private var startScale: Double = 1.0
  private var endScale: Double = 2.66
  private let circleCount = 4

  //TODO: use our static purple color from Sclera
  private var circleColor: CGColor = UIColor(red:60.0/256.0,
                                             green:16.0/256.0,
                                             blue:83.0/256.0,
                                             alpha:1.0).cgColor

  /// - warning: If this changes without setting a new image in the asset catalog,
  ///            it will cause a crash
  private let mainImage: UIImage! = {
    return UIImage(named: "pair_60x60")!
  }()

  /// layer for the image that is in the middle of the animation
  private var imageLayer: CALayer!

  // MARK: Animation Keys
  fileprivate let scaleKey = "transform.scale"
  fileprivate let opacityKey = "opacity"
  fileprivate let kAnimationKey = "opacity"

  // MARK: UIVIew Functions

  /// - Parameter aDecoder: An unarchiver object.
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  /// - Parameter frame: An CGRect for frame size
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  /// Shared setup logic for both initializers
  private func setup() {
    self.backgroundColor = UIColor.clear

    let imageLayer = CALayer()
    let dx = (self.frame.size.width - mainImage.size.width) / 2.0
    let dy = (self.frame.size.height - mainImage.size.height) / 2.0
    let centerPoint = CGPoint(x: dx, y: dy)
    imageLayer.frame = CGRect(origin: centerPoint, size: mainImage.size)
    imageLayer.contents = mainImage.cgImage
    self.imageLayer = imageLayer

    startAnimation()
  }

  // MARK: Animation Functions

  /// Start the Pairing Animation
  func startAnimation() {
    setupCircles()
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
    for idx in 0 ..< circleCount {
      let dx = self.frame.size.width  / 2.0
      let dy = self.frame.size.height / 2.0
      let centerPoint = CGPoint(x: dx, y: dy)
      let circleShape = HomeAnimationView.diskLayer(radius: mainImage.size.width / 2.0,
                                                    origin: centerPoint,
                                                     color: circleColor)
      self.layer.addSublayer(circleShape)
      let animation = animationWithIndex(index: idx, total: circleCount - 1)
      circleShape.add(animation, forKey: kAnimationKey)
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
  private static func diskLayer(radius: CGFloat,
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
