//
//  SaveAddressPresenter.swift
//  i2app
//
//  Arcus Team on 3/14/17.
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
import PromiseKit

protocol SaveAddressPresenterProtocol {
  weak var saveAddressDelegate: SaveAddressDelegate? {get set}

  init (currentPlace: PlaceModel)
  func saveAddress(delegate: SaveAddressDelegate, address: [String:String])
}

protocol SaveAddressDelegate: class {
  func onSaveError()
  func onSaveSuccess(_ needsTimezoneUpdate: Bool, needsPermit: Bool)
  func onShowProMonNotAvailable()       // Address where ProMon is not offered
  func onShowProMonNotServiced()        // Address where ProMon is offered, but no local authorities service the area

}

class SaveAddressPresenter: SaveAddressPresenterProtocol {

  weak var saveAddressDelegate: SaveAddressDelegate?

  var currentPlace: PlaceModel

  let settingsProvider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

  required init (currentPlace: PlaceModel) {
    self.currentPlace = currentPlace
    _ = self.currentPlace.refresh()
  }

  func saveAddress(delegate: SaveAddressDelegate, address: [String:String]) {
    self.saveAddressDelegate = delegate
    let cannonicalizedAddress = VerifyAddressPresenter.cannonicalizeAddress(address: address)

    _ = PlaceCapability.updateAddress(withStreetAddress: cannonicalizedAddress, on: self.currentPlace)
      .swiftThen({ (_) -> (PMKPromise?) in
        self.refreshPlaceModelAndSave()
        return nil
      })
      .swiftCatch({ (error) -> (PMKPromise?) in
        if let errorResponse = error as? NSError,
          let errorCode = errorResponse.userInfo["code"] as? String {
          if (errorCode as NSString).contains("address.invalid") ||
            (errorCode as NSString).contains("address.unavailable") ||
            (errorCode as NSString).contains("address.unsupported") {
            self.saveAddressDelegate?.onShowProMonNotAvailable()
            return nil
          } else if (errorCode as NSString).contains("address.unserviceable") {
            self.saveAddressDelegate?.onShowProMonNotServiced()
            return nil
          }
        }

        self.saveAddressDelegate?.onSaveError()
        return nil
      })
  }

  fileprivate func refreshPlaceModelAndSave() {
    _ = self.currentPlace.refresh().swiftThen({ (_) -> (PMKPromise?) in
      self.determineIfPermitRequiredAndSave()
        return nil
    }).swiftCatch({ (_) -> (PMKPromise?) in
      self.saveAddressDelegate?.onSaveError()
      return nil
    })
  }

  private func determineIfPermitRequiredAndSave() {
    self.settingsProvider.modelForPlaceId(self.currentPlace.modelId as String)
      .swiftThen({ response in
        guard let model = response as? ProMonitoringSettingsModel else { return nil }

        let permitRequired = ProMonitoringSettingsCapability.getPermitRequired(from: model)
          && ProMonitoringSettingsCapability.getPermitNumber(from: model).isEmpty

        self.saveSuccessfully(permitRequired: permitRequired)

        return nil
      })
      .swiftCatch({ (_) -> (PMKPromise?) in
        self.saveAddressDelegate?.onSaveError()
        return nil
      })
  }

  private func saveSuccessfully(permitRequired: Bool) {
    if PlaceCapability.getAddrCounty(from: self.currentPlace).isEmpty {
      self.saveAddressDelegate?.onSaveSuccess(true, needsPermit: permitRequired)
    } else {
      self.saveAddressDelegate?.onSaveSuccess(false, needsPermit: permitRequired)
    }
  }
}
