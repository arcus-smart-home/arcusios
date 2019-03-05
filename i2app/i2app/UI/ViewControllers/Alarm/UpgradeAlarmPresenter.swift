//
//  UpgradeAlarmPresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/3/17.
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

protocol UpgradeAlarmPresenter {
  weak var delegate: UpgradeAlarmDelegate? { get set }
  var alarmSubsystem: SubsystemModel! { get set }

  func upgradeAlarm()
  var upgradeSuccessul: Bool { get set }
}

protocol UpgradeAlarmDelegate: class {
  func alarmUpgradeSuccessful()
  func alarmUpgradeFailed()
}

class UpgradePresenter: UpgradeAlarmPresenter, SubsystemStateProvider {
  weak var delegate: UpgradeAlarmDelegate?
  var alarmSubsystem: SubsystemModel!
  var upgradeSuccessul: Bool = false

  required init(delegate: UpgradeAlarmDelegate, alarmSubsystem: SubsystemModel) {
    self.delegate = delegate
    self.alarmSubsystem = alarmSubsystem

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(subsystemUpdatedNotificationReceived(_:)),
                   name: Notification.Name.subsystemCacheUpdated,
                   object: nil)
  }

  @objc func subsystemUpdatedNotificationReceived(_ notification: Notification) {
    DispatchQueue.global(qos: .background).async {

    }
  }

  func upgradeAlarm() {
    DispatchQueue.global(qos: .background).async {
      _ = self.activateSubsystem(self.alarmSubsystem)
        .swiftThenInBackground({
          _ in
          self.processUpgradeResult()
          return nil
        })
        .swiftCatch({
          _ in
          self.processUpgradeResult()
          return nil
        })
    }
  }

  private func processUpgradeResult() {
    self.upgradeSuccessul = (self.subsystemState(self.alarmSubsystem) == kEnumSubsystemStateACTIVE)
    if self.upgradeSuccessul == true {
      self.delegate?.alarmUpgradeSuccessful()
    } else {
      self.delegate?.alarmUpgradeFailed()
    }
  }
}
