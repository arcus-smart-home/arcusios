//
//  DashboardDoorsLocksProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/1/17.
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

protocol DashboardDoorsLocksProvider {
  // MARK: Extended
  func fetchDashboardDoorsLocks()
}

extension DashboardDoorsLocksProvider where Self: DashboardProvider {
  func fetchDashboardDoorsLocks() {
    let doorsLocksData = DashboardDoorsLocksViewModel()

    if let controller: DoorsNLocksSubsystemController =
      SubsystemsController.sharedInstance().doorsNLocksController {
      if controller.hasDevices {
        doorsLocksData.isEnabled = true
        doorsLocksData.openedDoorCount = controller.openedContactSensorDeviceAddresses.count
        doorsLocksData.openedLockCount = controller.unlockedDoorLockDeviceAddresses.count
          + controller.openedPetDoorDeviceAddresses.count
          + controller.autoPetDoorDeviceAddresses.count

        doorsLocksData.openedGarageCount = controller.openedGarageDoorDeviceAddresses.count
      }
    }

    self.storeViewModel(doorsLocksData)
  }
}
