//
//  LutronBridgeC2CPresenter.swift
//  i2app
//
//  Created by Arcus Team on 10/19/17.
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

// MARK - Dependencies
// : depending on abstractions not concretions

protocol DeviceArrayGettable {
  var devicesArray: [Any] { get }
}

extension DeviceManager: DeviceArrayGettable {
  var devicesArray: [Any] {
    return self.devices ?? []
  }
}

protocol LutronBridgeC2CPresenterProtocol {
  /**
   Retrieves the configured URL string for the pairing screen.

   - returns: The URL string for pairing or empty if the currentPlace.modelId is not configured.

   */
  var pairURLRequest: URLRequest? { get }

  /**
   Retrieves devices
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

class LutronBridgeC2CPresenter: LutronBridgeC2CPresenterProtocol {

  var devices = [DeviceModel]()
  private var revokedDevices = [DeviceModel]()

  private var lutronLoginBaseUrl: String?
  private var currentPlaceModelId: String?
  private var deviceModelsGettable: DeviceArrayGettable
  private var sessionToken: String?

  init(lutronLoginBaseUrl: String? = RxCornea.shared.session?.sessionInfo?.lutronLoginBaseUrl,
       currentPlaceModelId: String? = RxCornea.shared.settings?.currentPlace?.modelId,
       deviceArrayGettable: DeviceArrayGettable = DeviceManager.instance(),
       sessionToken: String? = RxCornea.shared.session?.token?.value) {
    self.lutronLoginBaseUrl = lutronLoginBaseUrl
    self.currentPlaceModelId = currentPlaceModelId
    self.deviceModelsGettable = deviceArrayGettable
    self.sessionToken = sessionToken
  }

  var pairURLRequest: URLRequest? {
    guard let baseURL = lutronLoginBaseUrl,
      let placeId = currentPlaceModelId,
      let sessionToken = sessionToken else {
        return nil
    }
    let urlString = baseURL + "?place=" + placeId
    guard let url = URL(string: urlString) else {
      return nil
    }

    let cookieProperties: [HTTPCookiePropertyKey : Any] = [
      .name: "arcusAuthToken",
      .value: sessionToken,
      .originURL: url,
      .path: "/",
      .expires: NSDate().addingDays(1)
    ]

    if let cookie = HTTPCookie(properties: cookieProperties) {
      let cookieJar = HTTPCookieStorage.shared
      cookieJar.setCookie(cookie)
    }

    return URLRequest(url: url)
  }

  func reconnectedDevices() -> [DeviceModel] {
    var reconnectedDevices = [DeviceModel]()

    for device in revokedDevices {
      let errors =  DeviceAdvancedCapability.getErrorsFrom(device)

      if errors == nil || errors?.count == 0 || errors!["ERR_UNAUTHED"] == nil {
        reconnectedDevices.append(device)
      }
    }

    return reconnectedDevices
  }

  func fetchRevokedDevices() {
    devices = [DeviceModel]()
    revokedDevices = [DeviceModel]()
    let lutronProductIDs = ["d8ceb2", "7b2892", "3420b0", "0f1b61", "e44e37"]

    let instanceDevices = deviceModelsGettable.devicesArray
    for device in instanceDevices {
      if let device = device as? DeviceModel,
        let productID = device.productId,
        lutronProductIDs.contains(productID) {
        devices.append(device)

        let errors = DeviceAdvancedCapability.getErrorsFrom(device)
        if errors != nil && errors!.count > 0 && errors!["ERR_UNAUTHED"] != nil {
          revokedDevices.append(device)
        }
      }
    }
  }

}
