//
//  ProMonWhoSettingsPresenter.swift
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

protocol ProMonWhoSettingsPresenterProtocol {
  weak var proMonWhoSettingsDelegate: ProMonWhoSettingsDelegate? {get set}
  init (delegate: ProMonWhoSettingsDelegate, placeId: String)

  func saveAdultsCount(_ adults: Int)
  func saveChildrenCount(_ children: Int)
  func savePetsCount(_ pets: Int)
}

protocol ProMonWhoSettingsDelegate: class {
  func showWhoResidesHere(_ adults: Int, children: Int, pets: Int)
  func onSaveError()
}

class ProMonWhoSettingsPresenter: ProMonWhoSettingsPresenterProtocol, ProMonitoringSettingsController {

  weak var proMonWhoSettingsDelegate: ProMonWhoSettingsDelegate?
  var proMonitoringSettingsModel: ProMonitoringSettingsModel?
  var settingsPovider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

  required init (delegate: ProMonWhoSettingsDelegate, placeId: String) {
    proMonWhoSettingsDelegate = delegate

    _ = self.settingsPovider.modelForPlaceId(placeId).swiftThen({
      response in
      if let model = response as? ProMonitoringSettingsModel {
        _ = model.refresh().swiftThen { _ in
          self.proMonitoringSettingsModel = model
          self.proMonWhoSettingsDelegate?.showWhoResidesHere(self.adultsCount(),
                                                              children: self.childrenCount(),
                                                              pets: self.petsCount())
          return nil
        }
      }
      return nil
    })
  }

  func saveAdultsCount(_ adults: Int) {
    _ = self.adultsCount(adults).swiftCatch({ (_) -> (PMKPromise?) in
      self.proMonWhoSettingsDelegate?.onSaveError()
      return nil
    })
  }

  func saveChildrenCount(_ children: Int) {
    _ = self.childrenCount(children).swiftCatch({ (_) -> (PMKPromise?) in
      self.proMonWhoSettingsDelegate?.onSaveError()
      return nil
    })
  }

  func savePetsCount(_ pets: Int) {
    _ = self.petsCount(pets).swiftCatch({ (_) -> (PMKPromise?) in
      self.proMonWhoSettingsDelegate?.onSaveError()
      return nil
    })
  }

}
