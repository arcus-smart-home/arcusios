//
//  ProMonPermitSettingsPresenter.swift
//  i2app
//
//  Arcus Team on 2/15/17.
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

protocol ProMonPermitSettingsPresenterProtocol {
  weak var proMonPermitSettingsDelegate: ProMonPermitSettingsDelegate? {get set}
  init (delegate: ProMonPermitSettingsDelegate, placeId: String)

  func savePermit(_ permit: String)
}

protocol ProMonPermitSettingsDelegate: class {
  func showPermit(_ permit: String?)
  func onPermitSaveSuccess()
  func onPermitSaveError()
}

class ProMonPermitSettingsPresenter: ProMonPermitSettingsPresenterProtocol, ProMonitoringSettingsController {

  weak var proMonPermitSettingsDelegate: ProMonPermitSettingsDelegate?
  var proMonitoringSettingsModel: ProMonitoringSettingsModel?
  var settingsProvider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

  required init(delegate: ProMonPermitSettingsDelegate, placeId: String) {
    proMonPermitSettingsDelegate = delegate

    DispatchQueue.global(qos: .background).async {
      _ = self.settingsProvider.modelForPlaceId(placeId).swiftThen({
        response in
        if let model = response as? ProMonitoringSettingsModel {
          _ = model.refresh().swiftThen { _ in
            self.proMonitoringSettingsModel = model
            self.proMonPermitSettingsDelegate?.showPermit(self.permitNumber())

            return nil
          }
        }
        return nil
      })
    }

  }

  func savePermit(_ permit: String) {
    DispatchQueue.global(qos: .background).async {
      _ = self.permitNumber(permit).swiftThen({ (_) -> (PMKPromise?) in
        self.proMonPermitSettingsDelegate?.onPermitSaveSuccess()
        return nil
      }).swiftCatch({ (_) -> (PMKPromise?) in
        self.proMonPermitSettingsDelegate?.onPermitSaveError()
        return nil
      })
    }
  }
}
