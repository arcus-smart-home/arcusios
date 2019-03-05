//
//  ProMonResponderSettingsPresenter.swift
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

protocol ProMonResponderSettingsPresenterProtocol {
  weak var proMonResponderSettingsDelegate: ProMonResponderSettingsDelegate? {get set}
  init (delegate: ProMonResponderSettingsDelegate, placeId: String)

  func saveResponderInstructions(_ responderInfo: String)
}

protocol ProMonResponderSettingsDelegate: class {
  func showResponderInstructions(_ responderInfo: String?)
  func onResponderSaveSuccess()
  func onResponderSaveError()
}

class ProMonResponderSettingsPresenter: ProMonResponderSettingsPresenterProtocol,
ProMonitoringSettingsController {
  weak var proMonResponderSettingsDelegate: ProMonResponderSettingsDelegate?
  var proMonitoringSettingsModel: ProMonitoringSettingsModel?
  var settingsProvider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

  required init(delegate: ProMonResponderSettingsDelegate, placeId: String) {
    proMonResponderSettingsDelegate = delegate

    DispatchQueue.global(qos: .background).async {
      _ = self.settingsProvider.modelForPlaceId(placeId).swiftThen({
        response in
        if let model = response as? ProMonitoringSettingsModel {
          _ = model.refresh().swiftThen { _ in
            self.proMonitoringSettingsModel = model
            self.proMonResponderSettingsDelegate?.showResponderInstructions(self.responderInstructions())

            return nil
          }
        }
        return nil
      })
    }
  }

  func saveResponderInstructions(_ responderInstructions: String) {
    DispatchQueue.global(qos: .background).async {
      _ = self.responderInstructions(responderInstructions).swiftThen({ (_) -> (PMKPromise?) in
        self.proMonResponderSettingsDelegate?.onResponderSaveSuccess()
        return nil
      }).swiftCatch({ (_) -> (PMKPromise?) in
        self.proMonResponderSettingsDelegate?.onResponderSaveError()
        return nil
      })
    }
  }
}
