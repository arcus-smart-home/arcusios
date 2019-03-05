//
//  AccountCreationConfettiView.swift
//  i2app
//
//  Created by Arcus Team on 10/13/17.
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

import CocoaLumberjack

/*
 This view displays a confetti animation with particles moving down from the top to the bottom of the screen. To 
 start the animation the function startConfetti() needs to be called.
 */
class AccountCreationConfettiView: UIView {
  private var emitter: CAEmitterLayer?

  private let colors: [UIColor] = [
    Appearance.errorPink,
    Appearance.securityBlue,
    Appearance.waterLeakTeal,
    Appearance.warningYellow,
    Appearance.carePurple
  ]

  private let images = [
    UIImage(named: "ConfettiBoxImage"),
    UIImage(named: "ConfettiTriangleImage"),
    UIImage(named: "ConfettiCircleImage")
  ]

  /*
   Starts the confetti animation.
   */
  func startConfetti() {
    // Remove a previous emitter layer if one already exists
    if let emitter = emitter {
      emitter.removeFromSuperlayer()
      self.emitter = nil
    }

    let newEmitter = createEmitterLayer()
    layer.addSublayer(newEmitter)
    emitter = newEmitter

    setupAnimationFor(emitter: emitter)
  }

  private func setupAnimationFor(emitter: CAEmitterLayer?) {
    emitter?.beginTime = CACurrentMediaTime()
    emitter?.birthRate = 1.0
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      emitter?.birthRate = 0.0
    }
  }

  private func createEmitterLayer() -> CAEmitterLayer {
    let emitter = CAEmitterLayer()
    emitter.emitterPosition = CGPoint(x: frame.size.width / 2, y: -10)
    emitter.emitterShape = kCAEmitterLayerLine
    emitter.emitterSize = CGSize(width: frame.size.width, height: 2.0)
    emitter.emitterCells = generateEmitterCells()
    emitter.birthRate = 0.0
    return emitter
  }

  private func generateEmitterCells() -> [CAEmitterCell] {
    var cells = [CAEmitterCell]()
    for index in 0..<120 {

      let cell = CAEmitterCell()

      cell.birthRate = 1.0
      cell.lifetime = 14.0
      cell.lifetimeRange = 0
      cell.velocity = CGFloat(getRandomVelocity())
      cell.velocityRange = 0
      cell.emissionLongitude = CGFloat(Double.pi)
      cell.emissionRange = 0.5
      cell.spin = 3.5
      cell.spinRange = 0
      cell.color = getNextColor(i: index)
      cell.contents = getNextImage(i: index)
      cell.scale = 0.15

      cells.append(cell)
    }
    return cells
  }

  private func getRandomVelocity() -> Int {
    let randomNumber = Int(arc4random_uniform(UInt32(100)))
    return 100 + randomNumber
  }

  private func getNextColor(i: Int) -> CGColor {
    let randomNumber = Int(arc4random_uniform(UInt32(colors.count)))
    return colors[randomNumber].cgColor
  }

  private func getNextImage(i: Int) -> CGImage? {
    let randomNumber = Int(arc4random_uniform(UInt32(images.count)))

    guard randomNumber < images.count, let image = images[randomNumber], let cgImage = image.cgImage else {
      DDLogError("Unexpected value attempting to generate image for confetti view.")
      return nil
    }

    return cgImage
  }
}
