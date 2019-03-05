//
//  ProMonDirectionsSettingsPresenter.swift
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

protocol ProMonDirectionsSettingsPresenterProtocol {
  weak var proMonDirectionsSettingsDelegate: ProMonDirectionsSettingsDelegate? {get set}
  init (delegate: ProMonDirectionsSettingsDelegate, placeId: String)

  func saveAdditionalDirections(_ additionalDirections: String)
}

protocol ProMonDirectionsSettingsDelegate: class {
  func showDirections(_ additionalDirections: String?)
  func onDirectionsSaveSuccess()
  func onDirectionsSaveError()
}

class ProMonDirectionsSettingsPresenter: ProMonDirectionsSettingsPresenterProtocol,
ProMonitoringSettingsController {
  weak var proMonDirectionsSettingsDelegate: ProMonDirectionsSettingsDelegate?
  var proMonitoringSettingsModel: ProMonitoringSettingsModel?
  var settingsProvider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

  required init(delegate: ProMonDirectionsSettingsDelegate, placeId: String) {
    proMonDirectionsSettingsDelegate = delegate

    DispatchQueue.global(qos: .background).async {
      _ = self.settingsProvider.modelForPlaceId(placeId).swiftThen({
        response in
        if let model = response as? ProMonitoringSettingsModel {
          _ = model.refresh().swiftThen { _ in
            self.proMonitoringSettingsModel = model
            self.proMonDirectionsSettingsDelegate?.showDirections(self.additionalDirections())

            return nil
          }
        }
        return nil
      })
    }

  }

  func saveAdditionalDirections(_ additionalDirections: String) {
    DispatchQueue.global(qos: .background).async {
      _ = self.additionalDirections(additionalDirections).swiftThen({ (_) -> (PMKPromise?) in
        self.proMonDirectionsSettingsDelegate?.onDirectionsSaveSuccess()
        return nil
      }).swiftCatch({ (_) -> (PMKPromise?) in
        self.proMonDirectionsSettingsDelegate?.onDirectionsSaveError()
        return nil
      })
    }
  }
}
