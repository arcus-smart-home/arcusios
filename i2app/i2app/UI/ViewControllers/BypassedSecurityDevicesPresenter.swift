//
//  BypassedSecurityDevicesPresenter.swift
//  i2app
//
//  Created by Arcus Team on 5/8/17.
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

protocol BypassedSecurityDevicesPresenter {
  weak var delegate: BypassedSecurityDevicesDelegate? { get set }
  var devices: [BypassedSecurityDeviceViewModel] { get set }
  var offlineIncluded: Bool { get set }
  var bypassedIncluded: Bool { get set }

  func setUp()
}

protocol BypassedSecurityDevicesDelegate: class {
  func updateLayout()
}

class BypassedOfflineDevicesPresenter: BypassedSecurityDevicesPresenter {
  weak var delegate: BypassedSecurityDevicesDelegate?
  var devices: [BypassedSecurityDeviceViewModel] = [BypassedSecurityDeviceViewModel]()
  internal var deviceModels: [DeviceModel]?
  var offlineIncluded: Bool = false
  var bypassedIncluded: Bool = false

  required init(_ delegate: BypassedSecurityDevicesDelegate?, deviceModels: [DeviceModel]) {
    self.delegate = delegate
    self.deviceModels = deviceModels
    setUp()
  }

  func setUp() {
    if let models = deviceModels {
      let deviceViewModels = models.map {
        (value: DeviceModel) -> BypassedSecurityDeviceViewModel in
        let name = value.name
        let state = DeviceConnectionCapability.getStateFrom(value)
        let isOffline = (state == kEnumDeviceConnectionStateOFFLINE)

        return BypassedOfflineDeviceViewModel(name, isOffline: isOffline)
      }

      let bypassed = deviceViewModels.filter { $0.isOffline == false }
      let offline = deviceViewModels.filter { $0.isOffline == true }

      DispatchQueue.main.async {
        self.offlineIncluded = offline.count > 0
        self.bypassedIncluded = bypassed.count > 0
        self.devices = deviceViewModels.sorted { $0.name < $1.name }
        self.delegate?.updateLayout()
      }
    }
  }
}
