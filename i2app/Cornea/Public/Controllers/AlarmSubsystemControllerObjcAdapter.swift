//
//  AlarmSubsystemControllerObjcAdapter.swift
//  i2app
//
//  Arcus Team on 2/13/17.
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

@objc open class AlarmSubsystemControllerObjcAdapter: NSObject {
  fileprivate let mixin: AlarmSubsystemMixin?

  fileprivate class AlarmSubsystemMixin: AlarmSubsystemController {
    var subsystemModel: SubsystemModel

    required init (_ model: SubsystemModel) {
      subsystemModel = model
    }
  }

  required public override init() {
    if let model = SubsystemCache.sharedInstance.alarmSubsystem() {
      mixin = AlarmSubsystemMixin(model)
    } else {
      mixin = nil
    }

    super.init()
  }

  func activeMonitoredAlerts() -> [String] {
    if let models = mixin?.alarmModels(SubsystemCache.sharedInstance.alarmSubsystem()) {
      var activeAlerts: [String] = []

      for thisModel in models {
        let thisAlertState = AlarmCapability.getAlertState(from: thisModel)
        let isMonitored = AlarmCapability.getMonitoredFrom(thisModel)
        if let thisAlertName = thisModel.getAttribute(kMultiInstanceTypeKey) as? String {
          if isMonitored && thisAlertState != kEnumAlarmAlertStateINACTIVE {
            activeAlerts.append(thisAlertName)
          }
        }
      }

      return activeAlerts
    } else {
      return []
    }
  }
}
