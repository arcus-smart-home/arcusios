//
//  NestC2CPresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/27/17.
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

import Cornea

protocol NestC2CPresenterDelegate: class {
  
}

protocol NestC2CPresenterProtocol {
  /**
   Retrieves the configured URL string for the Nest pairing screen.
   
   - returns: The URL string for Nest pairing or empty if the currentPlace.modelId is not configured.
   
   */
  func nestPairURL() -> String

  /**
   Retrieves nest thermostat devices
   */
  func fetchRevokedDevices()

  /**
   List of devices that were previously revoked and are now reconnected. This function assumes that 
   fetchRevokedDevices() was called prior to reconencting the devices. If there were no reconnected 
   devices or if fetchRevokedDevices() was not called prior to reconnecting, this function will returned an
   empty array.
   
  - returns: The list of devices that have been reconnected.
   */
  func reconnectedDevices() -> [DeviceModel]
}

class NestC2CPresenter: NestC2CPresenterProtocol, NestThermostatOperationController {
  
  // MARK: Properties
  
  private weak var delegate: NestC2CPresenterDelegate?
  
  var nestDevices = [DeviceModel]()
  private var revokedDevices = [DeviceModel]()
  
  // MARK: Functions
  
  init(delegate: NestC2CPresenterDelegate) {
    self.delegate = delegate
  }

  func reconnectedDevices() -> [DeviceModel] {
    var reconnectedDevices = [DeviceModel]()

    for device in revokedDevices {
      let errors = getErrors(device)

      if errors == nil || errors?.count == 0 || errors!["ERR_UNAUTHED"] == nil {
        reconnectedDevices.append(device)
      }
    }

    return reconnectedDevices
  }
  
  func fetchRevokedDevices() {
    nestDevices = [DeviceModel]()
    revokedDevices = [DeviceModel]()

    if let devices = DeviceManager.instance().devices {
      for device in devices {
        if let device = device as? DeviceModel, device.deviceType == .thermostatNest {
          nestDevices.append(device)

          let errors = getErrors(device)
          if errors != nil && errors!.count > 0 && errors!["ERR_UNAUTHED"] != nil {
            revokedDevices.append(device)
          }
        }
      }
    }
  }
  
  func nestPairURL() -> String {
    var baseURL = ""
    if let url = RxCornea.shared.session?.sessionInfo?.nestLoginBaseUrl {
      baseURL = url
    }
    var clientId = ""
    if let client = RxCornea.shared.session?.sessionInfo?.nestClientId {
      clientId = client
    }
    var placeId = ""
    if let place = RxCornea.shared.settings?.currentPlace?.modelId {
      placeId = place
    }
    let state = "pair:" + placeId
    
    return baseURL + "?client_id=" + clientId + "&state=" + state
  }
}
