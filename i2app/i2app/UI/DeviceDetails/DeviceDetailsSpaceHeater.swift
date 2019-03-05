//
//  SpaceHeaterDeviceDetails.swift
//  i2app
//
//  Arcus Team on 8/15/16.
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

class DeviceDetailsSpaceHeater: DeviceDetailsBase {

  let alphaDisabled = 0.4 as CGFloat
  let alphaEnabled = 1.0 as CGFloat
  let executor = ThrottledExecutor(throttlePeriodSec: 0.5, quiescencePeriodSec: 0.5)

  weak var delegate: DeviceDetailsThermostatDelegate?
  var plusButton: DeviceButtonBaseControl?
  var minusButton: DeviceButtonBaseControl?
  var displayedSetpoint: Int?

  func onOnButton() {
    DispatchQueue.global(qos: .background).async {
      SpaceHeaterCapability.setHeatstate(kEnumSpaceHeaterHeatstateON, on: self.deviceModel)
      self.deviceModel.commit()
      self.updateDisplay()
    }
  }

  func onOffButton() {
    DispatchQueue.global(qos: .background).async {
      SpaceHeaterCapability.setHeatstate(kEnumSpaceHeaterHeatstateOFF, on: self.deviceModel)
      self.deviceModel.commit()
      self.updateDisplay()
    }
  }

  func onPlusButton () {
    let newTempInF = getDisplayedSetpoint() + 1
    if newTempInF <= DeviceController.getSpaceHeaterMaxSetpoint(for: deviceModel) {
      setDisplayedSetpoint(newTempInF)
      executor.execute({})
      executor.executeAfterQuiescence({
        self.setSetpointAdjusterDisabled(true)
        DeviceController.setSpaceHeaterSetpointForModel((Double)(newTempInF), on: self.deviceModel)
      })
    }
  }

  func onMinusButton () {
    let newTempInF = getDisplayedSetpoint() - 1
    if newTempInF >= DeviceController.getSpaceHeaterMinSetpoint(for: deviceModel) {
      setDisplayedSetpoint(newTempInF)
      executor.execute({})
      executor.executeAfterQuiescence({
        self.setSetpointAdjusterDisabled(true)
        DeviceController.setSpaceHeaterSetpointForModel((Double)(newTempInF), on: self.deviceModel)
      })
    }
  }

  func onModeButton () {
    let on = PopupSelectionButtonModel.create("ON", event: #selector(onOnButton))
    let off = PopupSelectionButtonModel.create("OFF", event: #selector(onOffButton))
    let popup = PopupSelectionButtonsView.create(withTitle: "POWER", buttons:[on!, off!])
    popup?.owner = self

    delegate?.popup(popup, complete:nil, withOwner:self)
  }

  func getDisplayedSetpoint () -> Int {
    return self.displayedSetpoint!
  }

  func setDisplayedSetpoint (_ setpoint: Int) {
    self.displayedSetpoint = setpoint
    updateDisplay()
  }

  func setSetpointAdjusterDisabled (_ disabled: Bool) {
    self.plusButton?.disable = disabled
    self.minusButton?.disable = disabled
    if disabled {
      self.plusButton?.alpha = alphaDisabled
      self.minusButton?.alpha = alphaDisabled
    } else {
      self.plusButton?.alpha = alphaEnabled
      self.minusButton?.alpha = alphaEnabled
    }
  }

  func updateDisplay () {
    DispatchQueue.main.async {
      let currentMode = SpaceHeaterCapability.getHeatstateFrom(self.deviceModel)
      let ecomode = TwinStarCapability.getEcomodeFrom(self.deviceModel)
      let currentTempInF = DeviceController.getTemperatureFor(self.deviceModel)
      var currentSetpoint = ""
      if ecomode == kEnumTwinStarEcomodeENABLED {
        currentSetpoint = "Ecomode"
      } else {
        currentSetpoint = String("\(self.getDisplayedSetpoint())°")
      }

      // Device is on
      if currentMode == kEnumSpaceHeaterHeatstateON {
        self.delegate?.setBottomButtonText("ON")
        self.delegate?.setSubtitle("Now \(currentTempInF)° Set \(currentSetpoint)")
      } else {
        self.delegate?.setBottomButtonText("OFF")

        if ecomode == kEnumTwinStarEcomodeENABLED {
          self.delegate?.setSubtitle("Set \(currentSetpoint)")
        } else {
          self.delegate?.setSubtitle(nil)
        }
      }

      let adjusterButtonsHidden =
        (currentMode == kEnumSpaceHeaterHeatstateOFF || ecomode == kEnumTwinStarEcomodeENABLED)
      self.plusButton?.isHidden=adjusterButtonsHidden
      self.minusButton?.isHidden=adjusterButtonsHidden
    }
  }

  @objc override func loadData() {
    self.plusButton = self.controlCell.rightButton
    self.minusButton = self.controlCell.leftButton
    self.delegate = self.controlCell
    self.displayedSetpoint = DeviceController.getSpaceHeaterSetpoint(for: self.deviceModel)

    self.plusButton!.setImageStyle(UIImage(named:"deviceThermostatPlusButton"),
                                   with: #selector(onPlusButton),
                                   owner:self)
    self.minusButton!.setImageStyle(UIImage(named:"deviceThermostatMinusButton"),
                                    with: #selector(onMinusButton),
                                    owner:self)

    self.delegate!.setButtonSelector(#selector(onModeButton),
                                     toOwner: self)
    updateDisplay()
  }

  @objc override func updateDeviceState(_ attributes: [AnyHashable: Any]!, initialUpdate isInitial: Bool) {
    self.displayedSetpoint = DeviceController.getSpaceHeaterSetpoint(for: self.deviceModel)

    setSetpointAdjusterDisabled(false)
    updateDisplay()
  }
}
