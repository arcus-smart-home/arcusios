//
//  ProMonGateSettingsPresenter.swift
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

protocol ProMonGateSettingsPresenterProtocol {
    weak var proMonGateSettingsDelegate: ProMonGateSettingsDelegate? {get set}
    init (delegate: ProMonGateSettingsDelegate, placeId: String)

    func saveGateCode(_ gateCode: String)
}

protocol ProMonGateSettingsDelegate: class {
    func showGate(_ gateCode: String?)
    func onGateSaveSuccess()
    func onGateSaveError()
}

class ProMonGateSettingsPresenter: ProMonGateSettingsPresenterProtocol, ProMonitoringSettingsController {

    weak var proMonGateSettingsDelegate: ProMonGateSettingsDelegate?
    var proMonitoringSettingsModel: ProMonitoringSettingsModel?
    var settingsProvider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

    required init(delegate: ProMonGateSettingsDelegate, placeId: String) {
        proMonGateSettingsDelegate = delegate

        DispatchQueue.global(qos: .background).async {
            _ = self.settingsProvider.modelForPlaceId(placeId).swiftThen({
                response in
                if let model = response as? ProMonitoringSettingsModel {
                  _ = model.refresh().swiftThen { _ in
                    self.proMonitoringSettingsModel = model
                    self.proMonGateSettingsDelegate?.showGate(self.gateCode())

                    return nil
                  }
                }
                return nil
            })
        }
    }

    func saveGateCode(_ gateCode: String) {
        DispatchQueue.global(qos: .background).async {
            _ = self.gateCode(gateCode).swiftThen({ (_) -> (PMKPromise?) in
                self.proMonGateSettingsDelegate?.onGateSaveSuccess()
                return nil
            }).swiftCatch({ (_) -> (PMKPromise?) in
                self.proMonGateSettingsDelegate?.onGateSaveError()
                return nil
            })
        }
    }
}
