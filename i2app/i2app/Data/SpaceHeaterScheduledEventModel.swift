//
//  SpaceHeaterScheduledEventModel.swift
//  i2app
//
//  Arcus Team on 8/16/16.
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

open class SpaceHeaterScheduledEventModel: ScheduledEventModel {

  var minSetpointF, maxSetpointF: Int?

  fileprivate override init () {
    super.init()
  }

  @objc init(minSetpointF: Int, maxSetpointF: Int) {
    self.minSetpointF = minSetpointF
    self.maxSetpointF = maxSetpointF
    super.init()
  }

  @objc init(eventDay: ScheduleRepeatType,
             withDelegate delegate: UIViewController!,
             minSetpointF: Int,
             maxSetpointF: Int) {
    self.minSetpointF = minSetpointF
    self.maxSetpointF = maxSetpointF
    super.init(eventDay: eventDay, withDelegate: delegate)
  }

  @objc open override func getScheduleEventOptions() -> [SchedulerSettingOption]! {
    let stateOption = SchedulerSettingOption.createSideValue("STATE",
                                                             sideValue: self.getHeaterStateString(),
                                                             eventOwner: self,
                                                             onClick: #selector(onStateSelected))
    let tempOption = SchedulerSettingOption.createSideValue("TEMPERATURE",
                                                            sideValue: "\(getSetpointInF())°",
      eventOwner: self,
      onClick: #selector(onTemperatureSelected))

    if getHeaterState() {
      return [stateOption!, tempOption!]
    }

    return [stateOption!]
  }

  @objc override open func getRepeatDescription() -> String! {
    return "If you have your device set in ECOMODE at time of scheduled event, the temperature chosen " +
      "for this event will override current ECOMODE setting. \n\n Tap below if you would like this event " +
    "to happen on multiple days."
  }

  @objc override open func copy(with zone: NSZone?) -> Any {
    let another = SpaceHeaterScheduledEventModel(minSetpointF: self.minSetpointF!,
                                                 maxSetpointF: self.maxSetpointF!)

    another.eventDay = self.eventDay
    if let eventTime = self.eventTime.copy() as? ArcusDateTime {
      another.eventTime = eventTime
    }
    another.eventId = self.eventId
    another.attributes = NSMutableDictionary(dictionary: self.attributes)
    another.messageType = self.messageType
    another.delegate = self.delegate
    another.originalCommand = self.originalCommand

    return another
  }

  func getHeaterStateString () -> String {
    if self.getHeaterState() {
      return "ON"
    }
    return "OFF"
  }

  func getHeaterState () -> Bool {
    if let state = attributes[kAttrSpaceHeaterHeatstate] as? String {
      return state == kEnumSpaceHeaterHeatstateON
    } else {
      attributes[kAttrSpaceHeaterHeatstate] = kEnumSpaceHeaterHeatstateON
      return true
    }
  }

  func setHeaterState (_ isOn: Bool) {
    if isOn {
      attributes[kAttrSpaceHeaterHeatstate] = kEnumSpaceHeaterHeatstateON
    } else {
      attributes[kAttrSpaceHeaterHeatstate] = kEnumSpaceHeaterHeatstateOFF
    }

    if let delegate = self.delegate as? ScheduledEventModelDelegate {
      delegate.reloadData()
    }
  }

  func getSetpointInF () -> Int {
    if let state = attributes[kAttrSpaceHeaterSetpoint] as? Double {
      return lround(DeviceController.celsius(toFahrenheit: state))
    } else {
      attributes[kAttrSpaceHeaterSetpoint] = DeviceController.fahrenheit(toCelsius: 75)
      return 75
    }
  }

  func setSetpointInF (_ setpoint: Int) {
    attributes[kAttrSpaceHeaterSetpoint] = DeviceController.fahrenheit(toCelsius: Double(setpoint))
    if let delegate = self.delegate as? ScheduledEventModelDelegate {
      delegate.reloadData()
    }
  }

  func onOnButton() {
    setHeaterState(true)
  }

  func onOffButton() {
    setHeaterState(false)
  }

  func onTemperatureChosen(_ value: NSObject) {
    if let selectedTemperature = value as? NSNumber {
      setSetpointInF(Int(selectedTemperature))
    }
  }

  func onStateSelected () {
    let on = PopupSelectionButtonModel.create("ON", event: #selector(onOnButton))
    let off = PopupSelectionButtonModel.create("OFF", event: #selector(onOffButton))
    let popup = PopupSelectionButtonsView.create(withTitle: "POWER", buttons:[on!, off!])
    popup?.owner = self

    if let delegate = self.delegate as? ScheduledEventModelDelegate {
      delegate.popup(popup, complete: nil, withOwner:self)
    }
  }

  func onTemperatureSelected () {
    let temperaturePopup = PopupSelectionNumberView.create("TEMPERATURE",
                                                           withMinNumber: CGFloat(minSetpointF!),
                                                           maxNumber: CGFloat(maxSetpointF!),
                                                           andPostfix: "°")

    if let delegate = self.delegate as? ScheduledEventModelDelegate {
      delegate.popup(temperaturePopup, complete: #selector(onTemperatureChosen), withOwner:self)
    }
  }
}
