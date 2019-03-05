//
//  AlarmModelController.swift
//  i2app
//
//  Created by Arcus Team on 2/1/17.
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

import PromiseKit
import Cornea

protocol AlarmModelController {
  func alertState(_ alarmModel: AlarmModel) -> String
  func devices(_ alarmModel: AlarmModel) -> [String]
  func excludedDevices(_ alarmModel: AlarmModel) -> [String]
  func activeDevices(_ alarmModel: AlarmModel) -> [String]
  func offlineDevices(_ alarmModel: AlarmModel) -> [String]
  func triggeredDevices(_ alarmModel: AlarmModel) -> [String]
  func getSecurityMode(_ subsystemModel: SubsystemModel) -> String
  func triggers(_ alarmModel: AlarmModel) -> [String]
  func getMonitored(_ alarmModel: AlarmModel) -> Bool
  func getSilent(_ alarmModel: AlarmModel) -> Bool
  func setSilent(_ silent: Bool, alarmModel: AlarmModel, parentSubsystem: SubsystemModel) -> PMKPromise
  func updateParentSubystem(_ alarmModel: AlarmModel, parentSubsystem: SubsystemModel) -> PMKPromise
}

extension AlarmModelController {
  func alertState(_ alarmModel: AlarmModel) -> String {
    return AlarmCapability.getAlertState(from: alarmModel)
  }

  func devices(_ alarmModel: AlarmModel) -> [String] {
    guard let devices = AlarmCapability
      .getDevicesFrom(alarmModel) as? [String] else {
        return [String]()
    }
    return devices
  }

  func excludedDevices(_ alarmModel: AlarmModel) -> [String] {
    guard let excludedDevices = AlarmCapability
      .getExcludedDevices(from: alarmModel) as? [String] else {
        return [String]()
    }
    return excludedDevices
  }

  func activeDevices(_ alarmModel: AlarmModel) -> [String] {
    guard let activeDevices = AlarmCapability
      .getActiveDevices(from: alarmModel) as? [String] else {
        return [String]()
    }
    return activeDevices
  }

  func offlineDevices(_ alarmModel: AlarmModel) -> [String] {
    guard let offlineDevices = AlarmCapability
      .getOfflineDevices(from: alarmModel) as? [String] else {
        return [String]()
    }
    return offlineDevices
  }

  func triggeredDevices(_ alarmModel: AlarmModel) -> [String] {
    guard let triggeredDevices = AlarmCapability
      .getTriggeredDevices(from: alarmModel) as? [String] else {
        return [String]()
    }
    return triggeredDevices
  }

  func triggers(_ alarmModel: AlarmModel) -> [String] {
    guard let triggers = AlarmCapability
      .getTriggersFrom(alarmModel) as? [String] else {
        return [String]()
    }
    return triggers
  }

  func getSecurityMode(_ subsystemModel: SubsystemModel) -> String {
    return AlarmSubsystemCapability.getSecurityMode(from: subsystemModel)
  }

  func getSecurityDisarmedTime(_ subsystemModel: SubsystemModel) -> Date? {
    return AlarmSubsystemCapability.getLastDisarmedTime(from: subsystemModel)
  }

  func getSecurityArmedTime(_ subsystemModel: SubsystemModel) -> Date? {
    return AlarmSubsystemCapability.getLastArmedTime(from: subsystemModel)
  }

  func getMonitored(_ alarmModel: AlarmModel) -> Bool {
    return AlarmCapability.getMonitoredFrom(alarmModel)
  }

  func getSilent(_ alarmModel: AlarmModel) -> Bool {
    return AlarmCapability.getSilentFrom(alarmModel)
  }

  func setSilent(_ silent: Bool, alarmModel: AlarmModel, parentSubsystem: SubsystemModel) -> PMKPromise {
    let returnVal: Bool = AlarmCapability.setSilent(silent, on: alarmModel)
    return updateParentSubystem(alarmModel, parentSubsystem: parentSubsystem)
    .swiftThen { (_) -> (PMKPromise?) in
      return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
        fulfiller?(returnVal)
      }
    }
  }

  func updateParentSubystem(_ alarmModel: AlarmModel, parentSubsystem: SubsystemModel) -> PMKPromise {
    return alarmModel.commit().swiftThenInBackground({
      res in
      if let parentAttributes: [String : AnyObject] =
        MultiCapabilityInstancedModelFactory.parentAttributes(alarmModel) {
        parentSubsystem.set(parentAttributes)
      }
      return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
        fulfiller?(res)
      }
    })
  }
}
