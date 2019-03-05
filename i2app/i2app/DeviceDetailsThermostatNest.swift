//
//  DeviceDetailsThermostatNest.swift
//  i2app
//
//  Created by Arcus Team on 7/6/17.
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

class DeviceDetailsThermostatNest: DeviceDetailsThermostat, NestThermostatOperationController {
  override func autoModeText() -> String! {
    return NSLocalizedString("HEAT ● COOL", comment: "")
  }

  override func loadData() {
    super.loadData()

    let errors = getErrors(deviceModel)
    
    if errors != nil && errors!.count > 0 && !deviceModel.isDeviceOffline() {
      if errors!["ERR_DELETED"] != nil {
        showDeviceRemoved()
      } else if errors!["ERR_UNAUTHED"] != nil {
        showRevokedBanner()
      } else if errors!["ERR_RATELIMIT"] != nil {
        showTimeoutBanner()
      } else {
        controlCell.teardownDeviceError()
      }
    }
  }

  private func showRevokedBanner() {
    DispatchQueue.main.async {
      self.controlCell.teardownDeviceError()
      self.controlCell.setupDeviceError("Nest account information revoked")
    }
  }
  
  private func showDeviceRemoved() {
    DispatchQueue.main.async {
      self.controlCell.teardownDeviceError()
      self.controlCell.setupDeviceError("Device removed in Nest")
    }
  }

  private func showTimeoutBanner() {
    DispatchQueue.main.async {
      self.controlCell.teardownDeviceError()
      self.controlCell.setupDeviceError("Temporary Timeout")
    }
  }
}
