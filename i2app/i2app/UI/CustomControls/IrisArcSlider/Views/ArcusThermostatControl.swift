//
//  ArcusThermostatControl.swift
//  i2app
//
//  Created by Arcus Team on 6/15/17.
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

enum ThermostatActiveHandle {
  case heatHandle
  case coolHandle
}

protocol ArcusThermostatControlDelegate: class {
  func modeButtonPressed(_ arcusThermostatControl: ArcusThermostatControl)
  func interactionStarted(_ arcusThermostatControl: ArcusThermostatControl)
  func interactionEnded(_ arcusThermostatControl: ArcusThermostatControl)
}

@IBDesignable @objc class ArcusThermostatControl: UIControl {

  weak var delegate: ArcusThermostatControlDelegate?
  var debounceInterval: TimeInterval = 2.0

  // MARK: Internal Elements

  private var backgroundArcView: ArcusArcView!
  private var temperatureArcView: ArcusArcView!
  private var rangeArcView: ArcusArcView!

  private let circle = CAShapeLayer()

  private var coolHandle = UIImageView(image: UIImage(named: "circletarget_icon-small-ios"))
  private var coolHandleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 18))

  private var heatHandle = UIImageView(image: UIImage(named: "circletarget_icon-small-ios"))
  private var heatHandleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 18))

  private var temperatureLockMin = UIImageView(image: UIImage(named: "circletarget_icon-small-ios"))
  private var temperatureLockMax = UIImageView(image: UIImage(named: "circletarget_icon-small-ios"))
  private var icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 27, height: 25))

  private var currentTemperatureBar: UIImageView!
  private var currentTemperatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 21))

  private var humidityIcon = UIImageView(image: UIImage(named: "haloHumidity"))
  private var humidityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 21))

  private var minusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
  private var plusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
  private var modeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 62, height: 42))

  private var thermostatTemperatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
  private var thermostatModeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 24))

  // MARK: Properties

  private(set) var viewModel = ThermostatControlViewModel()
  private(set) var activeHandle = ThermostatActiveHandle.heatHandle
  private var changeScheduler = Timer()
  private var activeStartAngle: CGFloat = 0
  private var isMovingHandle = false

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
    backgroundArcView = ArcusArcView(frame: CGRect(x: 0, y: 0, width: 340, height: 255))
    backgroundArcView.startAngle = ArcusArcMath.radians(135)
    backgroundArcView.endAngle = ArcusArcMath.radians(45)
    backgroundArcView.centerPoint = CGPoint(x: 170, y: 150)
    backgroundArcView.width = 26
    backgroundArcView.radius = 130 - (backgroundArcView.width/2)
    backgroundArcView.backgroundColor = UIColor.clear
    backgroundArcView.colorsArray = [UIColor.white.withAlphaComponent(0.3)]

    rangeArcView = ArcusArcView(frame: backgroundArcView.bounds)
    temperatureArcView = ArcusArcView(frame: backgroundArcView.bounds)

    modeButton.setImage(UIImage(named: "DeviceThermostatModeButton"), for: .normal)
    modeButton.center = CGPoint(x: backgroundArcView.center.x, y: backgroundArcView.centerPoint.y + 170)
    modeButton.isUserInteractionEnabled = true
    modeButton.addTarget(self, action: #selector(handleModeButton), for: .touchUpInside)

    plusButton.setImage(UIImage(named: "deviceThermostatPlusButton"), for: .normal)
    plusButton.center = CGPoint(x: modeButton.center.x + 80, y: modeButton.center.y)
    plusButton.isUserInteractionEnabled = true
    plusButton.addTarget(self, action: #selector(handlePlusButton(button:)), for: .touchUpInside)

    minusButton.setImage(UIImage(named: "deviceThermostatMinusButton"), for: .normal)
    minusButton.center = CGPoint(x: modeButton.center.x - 80, y: modeButton.center.y)
    minusButton.isUserInteractionEnabled = true
    minusButton.addTarget(self, action: #selector(handleMinusButton(button:)), for: .touchUpInside)

    currentTemperatureBar = UIImageView(image: UIImage(named: "currentbar_icon-small-ios"))
    coolHandle.backgroundColor = UIColor.clear
    heatHandle.backgroundColor = UIColor.clear

    humidityLabel.center = CGPoint(x: center.x + 3, y: backgroundArcView.center.y + 145)
    humidityIcon.center = CGPoint(x: center.x - 45, y: backgroundArcView.center.y + 143)

    temperatureLockMin.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    temperatureLockMax.frame = CGRect(x: 0, y: 0, width: 10, height: 10)

    setUpValueLabels()
    addCircle()

    icon.center = CGPoint(x: thermostatTemperatureLabel.center.x, y: thermostatTemperatureLabel.center.y + 60)

    layer.addSublayer(backgroundArcView.layer)
    layer.addSublayer(currentTemperatureLabel.layer)
    layer.addSublayer(thermostatTemperatureLabel.layer)
    layer.addSublayer(thermostatModeLabel.layer)
    layer.addSublayer(coolHandleLabel.layer)
    layer.addSublayer(heatHandleLabel.layer)
    layer.addSublayer(modeButton.layer)
    layer.addSublayer(plusButton.layer)
    layer.addSublayer(minusButton.layer)
    layer.addSublayer(humidityIcon.layer)
    layer.addSublayer(humidityLabel.layer)
    layer.addSublayer(rangeArcView.layer)
    layer.addSublayer(temperatureArcView.layer)
    layer.addSublayer(temperatureLockMin.layer)
    layer.addSublayer(temperatureLockMax.layer)
    layer.addSublayer(icon.layer)
    layer.addSublayer(currentTemperatureBar.layer)
    layer.addSublayer(coolHandle.layer)
    layer.addSublayer(heatHandle.layer)
  }

  override func setNeedsDisplay() {
    super.setNeedsDisplay()

    if backgroundArcView != nil {
      backgroundArcView.setNeedsDisplay()
    }

    if temperatureArcView != nil {
      temperatureArcView?.setNeedsDisplay()
    }

    if rangeArcView != nil {
      rangeArcView?.setNeedsDisplay()
    }
  }

  override func layoutSubviews() {
    backgroundArcView.frame = bounds

    super.layoutSubviews()
  }

  // MARK: Touch Handling

  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.beginTracking(touch, with: event)

    let touchPoint: CGPoint = touch.location(in: self)

    if thermostatTemperatureLabel.frame.contains(touchPoint) && viewModel.mode == .auto {
      toggleSelectedSetpoint()
      return false
    }

    delegate?.interactionStarted(self)

    if plusButton.frame.contains(touchPoint) {
      plusButton.sendActions(for: .touchUpInside)
    } else if minusButton.frame.contains(touchPoint) {
      minusButton.sendActions(for: .touchUpInside)
    } else if modeButton.frame.contains(touchPoint) {
      modeButton.sendActions(for: .touchUpInside)
    } else if coolHandle.frame.contains(touchPoint) {
      isMovingHandle = true
      activeHandle = .coolHandle
      highlightActiveSetpoint()
    } else if heatHandle.frame.contains(touchPoint) {
      isMovingHandle = true
      activeHandle = .heatHandle
      highlightActiveSetpoint()
    }

    return true
  }

  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.continueTracking(touch, with: event)
    
    guard isMovingHandle else {
      return true
    }

    let touchPoint: CGPoint = touch.location(in: self)
    
    moveHandle(touchPoint)

    return true
  }

  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)

    isMovingHandle = false
    delegate?.interactionEnded(self)
  }

  override func cancelTracking(with event: UIEvent?) {
    super.cancelTracking(with: event)
  }

  // MARK: Event Handling

  func handlePlusButton(button: UIButton) {
    guard viewModel.mode == .heat || viewModel.mode == .cool || viewModel.mode == .auto else {
      return
    }

    var temperature: Int

    if activeHandle == .heatHandle {
      temperature = viewModel.heatSetpoint + 1

    } else {
      temperature = viewModel.coolSetpoint + 1
    }

    if temperature > viewModel.temperatureLimitHigh {
      temperature = viewModel.temperatureLimitHigh
    }

    updateActiveSetpointToTemperature(temperature)
    scheduleChangeEvent()
    configureView()
  }

  func handleMinusButton(button: UIButton) {
    guard viewModel.mode == .heat || viewModel.mode == .cool || viewModel.mode == .auto else {
      return
    }

    var temperature: Int

    if activeHandle == .heatHandle {
      temperature = viewModel.heatSetpoint - 1
    } else {
      temperature = viewModel.coolSetpoint - 1
    }

    updateActiveSetpointToTemperature(temperature)

    scheduleChangeEvent()
    configureView()
  }

  func handleModeButton(button: UIButton) {
    delegate?.modeButtonPressed(self)
  }

  func emitChangeEvent() {
    sendActions(for: UIControlEvents.valueChanged)
  }

  // MARK: Public Configuration Methods

  func updateThermostatControl(_ viewModel: ThermostatControlViewModel) {
    self.viewModel = viewModel
    self.rangeArcView.isHidden = true

    configureView()
  }

  // MARK: Helpers

  private func configureView() {
    configureThermostatMode()
    configureTemperatureText()
    configureHumidity()
    configureCurrentTemperatureSetpoint()
    configureCoolHandle()
    configureHeatHandle()
    highlightActiveSetpoint()
    configureRangeArc()
    configureTemperatureArc()
    configureActionButtons()
    configureTemperatureLock()
    configureThermostatIcon()

    setNeedsDisplay()
  }

  private func configureThermostatIcon() {
    if let iconName = viewModel.iconImageName {
      icon.isHidden = false
      icon.image = UIImage(named: iconName)
    } else {
      icon.isHidden = true
    }
  }

  private func configureTemperatureLock() {
    if let minLock = viewModel.temperatureLockMin {
      let degrees = temperatureToDegrees(temperature: minLock)
      let angle = ArcusArcMath.radians(degrees)

      temperatureLockMin.isHidden = false
      temperatureLockMin.center = ArcusArcMath.pointForAngle(angle,
                                                            center: backgroundArcView.centerPoint,
                                                            radius: backgroundArcView.radius)
    } else {
      temperatureLockMin.isHidden = true
    }

    if let maxLock = viewModel.temperatureLockMax {
      let degrees = temperatureToDegrees(temperature: maxLock)
      let angle = ArcusArcMath.radians(degrees)

      temperatureLockMax.isHidden = false
      temperatureLockMax.center = ArcusArcMath.pointForAngle(angle,
                                                            center: backgroundArcView.centerPoint,
                                                            radius: backgroundArcView.radius)
    } else {
      temperatureLockMax.isHidden = true
    }
  }
  
  private func configureActionButtons() {
    switch viewModel.mode {
    case .off, .eco:
      plusButton.isHidden = true
      minusButton.isHidden = true
    default:
      plusButton.isHidden = false
      minusButton.isHidden = false
    }
  }

  private func configureCoolHandle() {
    if viewModel.mode == .cool || viewModel.mode == .auto {
      coolHandle.isHidden = false
      coolHandleLabel.isHidden = false
    } else {
      coolHandle.isHidden = true
      coolHandleLabel.isHidden = true
      return
    }

    let temperature = viewModel.coolSetpoint
    let temperatureLimitHigh = viewModel.temperatureLimitHigh
    let temperatureLimitLow = viewModel.temperatureLimitLow
    guard temperature >= temperatureLimitLow && temperature <= temperatureLimitHigh else {
      return
    }

    coolHandleLabel.text = "\(temperature)°"
    setPosition(forHanldle: coolHandle, toTemperature: temperature)
  }

  private func configureHeatHandle() {
    if viewModel.mode == .heat || viewModel.mode == .auto {
      heatHandle.isHidden = false
      heatHandleLabel.isHidden = false
    } else {
      heatHandle.isHidden = true
      heatHandleLabel.isHidden = true
      return
    }

    let temperature = viewModel.heatSetpoint
    let temperatureLimitHigh = viewModel.temperatureLimitHigh
    let temperatureLimitLow = viewModel.temperatureLimitLow
    guard temperature >= temperatureLimitLow && temperature <= temperatureLimitHigh else {
      return
    }

    heatHandleLabel.text = "\(temperature)°"
    setPosition(forHanldle: heatHandle, toTemperature: temperature)
  }

  private func configureHumidity() {
    guard let humidity = viewModel.humidity else {
      humidityIcon.isHidden = true
      humidityLabel.text = ""
      return
    }

    humidityIcon.isHidden = false
    humidityLabel.text = "\(humidity)%"
  }

  private func configureCurrentTemperatureSetpoint() {    
    let temperature = viewModel.currentTemperature
    let degrees = temperatureToDegrees(temperature: temperature)
    let angle = ArcusArcMath.radians(degrees)
    let point = ArcusArcMath.pointForAngle(angle, center: backgroundArcView.centerPoint,
                                          radius: backgroundArcView.radius)
    let newAngle = ArcusArcMath.angleForPoint(point, center: backgroundArcView.centerPoint)
    let adjustedAngle = (CGFloat.pi/2) - newAngle * -1
    let labelRadius = (backgroundArcView.radius) + currentTemperatureLabel.frame.width

    currentTemperatureBar.transform = CGAffineTransform(rotationAngle: adjustedAngle)
    currentTemperatureBar.center = point
    currentTemperatureBar.isHidden = false
    
    currentTemperatureLabel.text = "\(temperature)°"
    currentTemperatureLabel.isHidden = false
    currentTemperatureLabel.center = ArcusArcMath.pointForAngle(newAngle,
                                                               center: backgroundArcView.centerPoint,
                                                               radius: labelRadius)
  }

  private func configureTemperatureText() {
    switch viewModel.mode {
    case .auto:
      thermostatTemperatureLabel.text = "\(viewModel.heatSetpoint)°●\(viewModel.coolSetpoint)°"
    case .cool:
      thermostatTemperatureLabel.text = "\(viewModel.coolSetpoint)°"
    case .heat:
      thermostatTemperatureLabel.text = "\(viewModel.heatSetpoint)°"
    case .eco:
      thermostatTemperatureLabel.text = NSLocalizedString("ECO", comment: "")
    case .off:
      thermostatTemperatureLabel.text = NSLocalizedString("OFF", comment: "")
    }
  }

  private func configureThermostatMode() {
    switch viewModel.mode {
    case .auto:
      if let text = viewModel.customAutoModeText {
        thermostatModeLabel.text = text
      } else {
        thermostatModeLabel.text = NSLocalizedString("AUTO", comment: "")
      }
    case .cool:
      thermostatModeLabel.text = NSLocalizedString("COOL", comment: "")
      activeHandle = .coolHandle
    case .heat:
      activeHandle = .heatHandle
      thermostatModeLabel.text = NSLocalizedString("HEAT", comment: "")
    default:
      thermostatModeLabel.text = ""
      
    }
  }

  private func highlightActiveSetpoint() {
    guard viewModel.mode == .auto else {
      return
    }

    let first = "\(viewModel.heatSetpoint)°"
    let second = "\(viewModel.coolSetpoint)°"
    let white = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
    let attributes: [String: AnyObject] = [ NSForegroundColorAttributeName: white]
    let firstComponent: NSMutableAttributedString
    let secondComponent: NSMutableAttributedString

    if activeHandle == .heatHandle {
      firstComponent = NSMutableAttributedString(string: first)
      secondComponent = NSMutableAttributedString(string: "●\(second)", attributes: attributes)
    } else {
      firstComponent = NSMutableAttributedString(string: "\(first)●", attributes: attributes)
      secondComponent = NSMutableAttributedString(string: second)
    }

    firstComponent.append(secondComponent)
    thermostatTemperatureLabel.attributedText = firstComponent
  }

  private func setPosition(forHanldle handle: UIImageView, toTemperature temperature: Int) {
    let adjustedTemperature: Int
    if temperature == viewModel.currentTemperature + 1 {
      adjustedTemperature = viewModel.currentTemperature + 2
    } else if temperature == viewModel.currentTemperature - 1 {
      adjustedTemperature = viewModel.currentTemperature - 2
    } else {
      adjustedTemperature = temperature
    }

    let degrees = temperatureToDegrees(temperature: temperature)
    let adjustedDegrees = temperatureToDegrees(temperature: adjustedTemperature)
    let angle = ArcusArcMath.radians(degrees)
    let adjustedAngle = ArcusArcMath.radians(adjustedDegrees)
    let labelPosition = ArcusArcMath.pointForAngle(adjustedAngle,
                                                  center: backgroundArcView.centerPoint,
                                                  radius: backgroundArcView.radius + 30)

    handle.center = ArcusArcMath.pointForAngle(angle,
                                              center: backgroundArcView.centerPoint,
                                              radius: backgroundArcView.radius)

    if handle == coolHandle {
      coolHandleLabel.isHidden = viewModel.coolSetpoint == viewModel.currentTemperature
      coolHandleLabel.center = labelPosition
    } else {
      heatHandleLabel.isHidden = viewModel.heatSetpoint == viewModel.currentTemperature
      heatHandleLabel.center = labelPosition
    }
  }

  private func configureRangeArc() {
    guard viewModel.mode == .auto else {
      rangeArcView.isHidden = true
      return
    }

    let start = temperatureToDegrees(temperature: viewModel.heatSetpoint)
    let end = temperatureToDegrees(temperature: viewModel.coolSetpoint)
    let colors = [UIColor.white.withAlphaComponent(0.7)]

    rangeArcView.isHidden = false

    update(arcView: rangeArcView, withColors: colors, startAngle: start, endAngle: end)
  }

  private func configureTemperatureArc() {
    var start: Double?
    var end: Double?
    let lightOrange = UIColor(red: 226/255, green: 33/255, blue: 42/255, alpha: 1)
    let orange = UIColor(red: 239/255, green: 147/255, blue: 27/255, alpha: 1)
    let lightBlue = UIColor(red: 175/255, green: 221/255, blue: 232/255, alpha: 1)
    let blue = UIColor(red: 27/255, green: 143/255, blue: 210/255, alpha: 1)
    let white = UIColor.white.withAlphaComponent(0.7)
    var colors = [UIColor]()

    if viewModel.mode == .auto {
      if viewModel.coolSetpoint < viewModel.currentTemperature {
        end = temperatureToDegrees(temperature: viewModel.currentTemperature)
        start = temperatureToDegrees(temperature: viewModel.coolSetpoint)
        colors = [blue, lightBlue]
      } else if viewModel.heatSetpoint > viewModel.currentTemperature {
        start = temperatureToDegrees(temperature: viewModel.currentTemperature)
        end = temperatureToDegrees(temperature: viewModel.heatSetpoint)
        colors = [lightOrange, orange]
      }
    } else if viewModel.mode == .cool {
      if viewModel.coolSetpoint > viewModel.currentTemperature {
        end = temperatureToDegrees(temperature: viewModel.coolSetpoint)
        start = temperatureToDegrees(temperature: viewModel.currentTemperature)
        colors = [white]
      } else if viewModel.coolSetpoint < viewModel.currentTemperature {
        start = temperatureToDegrees(temperature: viewModel.coolSetpoint)
        end = temperatureToDegrees(temperature: viewModel.currentTemperature)
        colors = [blue, lightBlue]
      }
    } else if viewModel.mode == .heat {
      if viewModel.heatSetpoint < viewModel.currentTemperature {
        start = temperatureToDegrees(temperature: viewModel.heatSetpoint)
        end = temperatureToDegrees(temperature: viewModel.currentTemperature)
        colors = [white]
      } else if viewModel.heatSetpoint > viewModel.currentTemperature {
        end = temperatureToDegrees(temperature: viewModel.heatSetpoint)
        start = temperatureToDegrees(temperature: viewModel.currentTemperature)
        colors = [orange, lightOrange]
      }

    }

    if start == nil || end == nil {
      temperatureArcView.isHidden = true
      return
    }

    temperatureArcView.isHidden = false
    update(arcView: temperatureArcView, withColors: colors, startAngle: start!, endAngle: end!)
  }

  private func update(arcView: ArcusArcView,
                      withColors colors: [UIColor],
                      startAngle: Double,
                      endAngle: Double) {
    arcView.squareCap = true
    arcView.backgroundColor = UIColor.clear
    arcView.arcMode = .colorArray
    arcView.colorsArray = colors
    arcView.centerPoint = backgroundArcView.centerPoint
    arcView.radius = backgroundArcView.radius
    arcView.width = backgroundArcView.width
    arcView.startAngle = ArcusArcMath.radians(startAngle)
    arcView.endAngle = ArcusArcMath.radians(endAngle)
  }

  private func temperatureToDegrees(temperature: Int) -> Double {
    let temperatureLimitHigh: Int = viewModel.temperatureLimitHigh
    let temperatureLimitLow: Int = viewModel.temperatureLimitLow
    let startDegrees: Double = ArcusArcMath.degrees(backgroundArcView.startAngle)
    let endDegrees: Double = ArcusArcMath.degrees(backgroundArcView.endAngle)

    var newTemperature: Int = temperature
    if temperature > temperatureLimitHigh {
      newTemperature = temperatureLimitHigh
    }
    if temperature < temperatureLimitLow {
      newTemperature = temperatureLimitLow
    }

    let adjustedTemperature = Double((newTemperature - temperatureLimitLow) * 100)
    let percentage: Double = adjustedTemperature / Double(temperatureLimitHigh - temperatureLimitLow)
    let newDegree: Double = percentage * (360 - abs(startDegrees - endDegrees)) / 100

    return newDegree + startDegrees
  }

  private func degreesToTemperature(degrees: Double) -> Int {
    let temperatureLimitLow = viewModel.temperatureLimitLow
    let temperatureLimitHigh = viewModel.temperatureLimitHigh
    let startDegrees = ArcusArcMath.degrees(backgroundArcView.startAngle)
    let endDegrees = ArcusArcMath.degrees(backgroundArcView.endAngle)

    var adjustedNewDegree = degrees
    if degrees < startDegrees {
      adjustedNewDegree = degrees + 360
    }

    let percentage = (adjustedNewDegree - startDegrees) * 100 / (360 - abs(startDegrees - endDegrees))
    let newTemperature = Int(round(percentage * Double(temperatureLimitHigh - temperatureLimitLow) / 100))

    return temperatureLimitLow + newTemperature
  }

  private func addCircle() {
    let circleRadius = backgroundArcView.radius - backgroundArcView.width/2 - 5
    let circlePath = UIBezierPath(arcCenter: backgroundArcView.centerPoint,
                                  radius: circleRadius,
                                  startAngle: CGFloat(0),
                                  endAngle: CGFloat(Double.pi * 2),
                                  clockwise: true)

    circle.path = circlePath.cgPath
    circle.fillColor = UIColor.clear.cgColor
    circle.strokeColor = UIColor.white.cgColor
    circle.lineWidth = 1.0

    layer.addSublayer(circle)
  }

  private func setUpValueLabels() {
    setUpLabel(currentTemperatureLabel, withFontSize: 17)
    setUpLabel(thermostatModeLabel, withFontSize: 17)
    setUpLabel(coolHandleLabel, withFontSize: 17)
    setUpLabel(heatHandleLabel, withFontSize: 17)
    setUpLabel(thermostatTemperatureLabel, withFontSize: 40)
    setUpLabel(thermostatModeLabel, withFontSize: 17)
    setUpLabel(humidityLabel, withFontSize: 19)

    humidityLabel.textAlignment = .left
    thermostatTemperatureLabel.center = backgroundArcView.centerPoint
    thermostatModeLabel.center = CGPoint(x: frame.width/2, y: thermostatTemperatureLabel.center.x - 65)
  }

  private func setUpLabel(_ label: UILabel, withFontSize fontSize: CGFloat) {
    label.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
    label.textAlignment = .center
    label.textColor = UIColor.white
  }

  func moveHandle(_ point: CGPoint) {
    let newAngle = ArcusArcMath.angleForPoint(point, center: backgroundArcView.centerPoint)
    let newDegree = ((round(ArcusArcMath.degrees(newAngle)) + 360).truncatingRemainder(dividingBy: 360))
    let startDegrees = ArcusArcMath.degrees(backgroundArcView.startAngle)
    let endDegrees = ArcusArcMath.degrees(backgroundArcView.endAngle)
    let center = backgroundArcView.centerPoint

    if (newDegree <= endDegrees && point.x > center.x && point.y > center.y) ||
      (point.x >= center.x && point.y <= center.y) ||
      (point.x < center.x && newDegree >= startDegrees) {

      updateActiveSetpointToTemperature(degreesToTemperature(degrees: newDegree))

      configureView()
      scheduleChangeEvent()
    }
  }

  private func updateActiveSetpointToTemperature(_ temperature: Int) {
    let separation = viewModel.setpointSeparation
    var temperatureLimitHigh = viewModel.temperatureLimitHigh
    var temperatureLimitLow = viewModel.temperatureLimitLow
    var newTemperature = temperature

    if let newLimit = viewModel.temperatureLockMin {
      temperatureLimitLow = newLimit
    }
    if let newLimit = viewModel.temperatureLockMax {
      temperatureLimitHigh = newLimit
    }

    if viewModel.mode == .auto {
      if activeHandle == .heatHandle {
        let adjustedHigh = temperatureLimitHigh - separation

        if newTemperature < temperatureLimitLow {
          newTemperature = temperatureLimitLow
        }

        if newTemperature > adjustedHigh {
          newTemperature = adjustedHigh
        }
      } else {
        let adjustedLow = temperatureLimitLow + separation

        if newTemperature < adjustedLow {
          newTemperature = adjustedLow
        }

        if newTemperature > temperatureLimitHigh {
          newTemperature = temperatureLimitHigh
        }
      }
    } else {
      if newTemperature < temperatureLimitLow {
        newTemperature = temperatureLimitLow
      }

      if newTemperature > temperatureLimitHigh {
        newTemperature = temperatureLimitHigh
      }
    }

    if activeHandle == .heatHandle {
      viewModel.heatSetpoint = newTemperature

      if viewModel.coolSetpoint < viewModel.heatSetpoint + separation {
        viewModel.coolSetpoint = viewModel.heatSetpoint + separation
      }
    } else {
      viewModel.coolSetpoint = newTemperature

      if viewModel.heatSetpoint > viewModel.coolSetpoint - separation {
        viewModel.heatSetpoint = viewModel.coolSetpoint - separation
      }
    }
  }

  private func toggleSelectedSetpoint() {
    if activeHandle == .heatHandle {
      activeHandle = .coolHandle
    } else {
      activeHandle = .heatHandle
    }
    configureView()
  }

  private func scheduleChangeEvent() {
    changeScheduler.invalidate()
    changeScheduler = Timer.scheduledTimer(timeInterval: debounceInterval,
                                           target: self,
                                           selector: #selector(emitChangeEvent),
                                           userInfo: nil,
                                           repeats: false)
  }

}
