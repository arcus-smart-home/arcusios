//
//  NestThermostatOperationPresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/14/17.
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

protocol NestThermostatOperationPresenterProtocol: CommonThermostatOperationPresenterProtocol {

  var hasUnauthorizedError: Bool { get }

  var hasTimeoutError: Bool { get }

  var hasDeviceRemovedError: Bool { get }

  /**
    Fetches the thermostat data unique to nest thermostats
  */
  func fetchNestThermostatData()

  /**
    Text indicated the locked temperatures.
   
    @return Text with the locked temperatures. Empty if temperature is not locked.
   */
  func lockBannerText() -> String

  /**
   Text for the device removed banner
   
   @return Text with the content of the device removed banner. Empty if device is not deleted.
   */
  func deviceRemovedBannerText() -> String
  
  /**
   Text for the unauthorized banner

   @return Text with the content of the unauthorized banner. Empty if authorized.
   */
  func unauthorizedBannerText() -> String

  /**
   Text for the timeout banner

   @return Text with the content of the timeout banner. Empty if error is not set.
   */
  func timeoutBannerText() -> String
}

class NestThermostatOperationPresenter: NSObject, NestThermostatOperationPresenterProtocol,
  NestThermostatOperationController {

  weak private(set) var delegate: CommonThermostatOperationPresenterDelegate!
  var thermostatViewModel = ThermostatControlViewModel()
  var modesAvailable: [ThermostatMode] = [.heat, .cool, .auto, .eco, .off]
  private(set) var hasUnauthorizedError = false
  private(set) var hasTimeoutError = false
  private(set) var hasDeviceRemovedError = false

  required init(delegate: CommonThermostatOperationPresenterDelegate) {
    self.delegate = delegate
  }

  func lockBannerText() -> String {
    guard thermostatViewModel.isTemperatureLocked,
      let min = thermostatViewModel.temperatureLockMin,
      let max = thermostatViewModel.temperatureLockMax else {
      return ""
    }

    return NSLocalizedString("Temp. Locked \(min)° - \(max)°", comment: "")
  }
  
  func deviceRemovedBannerText() -> String {
    if hasDeviceRemovedError {
      return NSLocalizedString("Device removed in Nest", comment: "")
    }
    
    return ""
  }

  func unauthorizedBannerText() -> String {
    if hasUnauthorizedError {
      return NSLocalizedString("Nest account information revoked.", comment: "")
    }

    return ""
  }

  func timeoutBannerText() -> String {
    if hasTimeoutError {
      return NSLocalizedString("Temporary Timeout", comment: "")
    }

    return ""
  }

  func fetchNestThermostatData() {
    thermostatViewModel.customAutoModeText = NSLocalizedString("HEAT ● COOL", comment: "")

    thermostatViewModel.iconImageName = nil

    if hasLeaf(delegate.deviceModel) {
      thermostatViewModel.iconImageName = "eco_leaf_icon-small-ios"
    }

    if isTemperatureLocked(delegate.deviceModel) &&
        thermostatViewModel.mode != .off &&
        thermostatViewModel.mode != .eco {
      thermostatViewModel.isTemperatureLocked = true
      thermostatViewModel.temperatureLockMin =
        celsiusToFahrenheit(getLockTemperatureMin(delegate.deviceModel))
      thermostatViewModel.temperatureLockMax =
        celsiusToFahrenheit(getLockTemperatureMax(delegate.deviceModel))
    } else {
      thermostatViewModel.isTemperatureLocked = false
      thermostatViewModel.temperatureLockMin = nil
      thermostatViewModel.temperatureLockMax = nil
    }

    // Check for errors
    var errors = getErrors(delegate.deviceModel)

    // Reset existing errors
    hasUnauthorizedError = false
    hasTimeoutError = false
    hasDeviceRemovedError = false

    if errors != nil && errors!.count > 0 {
      if errors!["ERR_DELETED"] != nil {
        hasDeviceRemovedError = true
        thermostatViewModel.isTemperatureLocked = false
      } else if errors!["ERR_UNAUTHED"] != nil {
        hasUnauthorizedError = true
        thermostatViewModel.isTemperatureLocked = false
      } else if errors!["ERR_RATELIMIT"] != nil {
        hasTimeoutError = true
        thermostatViewModel.isTemperatureLocked = false
      }
    }

    delegate.updateThermostat()
  }
}
