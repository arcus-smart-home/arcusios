//
//  PresmokeAlertController.swift
//  i2app
//
//  Created by Arcus Team on 11/1/16.
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

let kShowPresmokeNotification: String = "ShowPreSmokeModalAlert"

class PresmokeAlertController: AlertController, AlertControllerProtocol {
  var presmokePresenter: PresmokeModalAlertPresenter?

  // MARK: Life Cycle

  required init(delegate: AlertControllerDelegate, currentPlace: PlaceModel) {
    super.init(delegate: delegate, currentPlace: currentPlace)
    observeAlertNotifications(presmokeNotifications(),
                              selector: #selector(alertNotificationReceived(_:)))
  }

  // MARK: Notification Response Handling

  func alertNotificationReceived(_ notification: Notification) {
    preventAlertDisplay = processPriorityAlarm()
    if preventAlertDisplay != true {
      if notification.name == Model
        .attributeChangedNotificationName(kAttrSafetySubsystemSmokePreAlert) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrSafetySubsystemSmokePreAlertDevices) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrSafetySubsystemLastSmokePreAlertTime) {
        processAlertEvent(notification)
      } else if notification.name.rawValue == Notification.Name.subsystemInitialized.rawValue ||
        notification.name.rawValue == kShowPresmokeNotification ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrSecuritySubsystemAlarmState) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrSafetySubsystemAlarm) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrCareSubsystemAlarmState) {
        processExistingAlertEvents()
      }
    } else {
      dismissAlertWithPresenter(presmokePresenter)
    }
  }

  func processAlertEvent(_ notification: Notification) {
    if let subsystem = notification.userInfo?["Model"] as? SubsystemModel,
      subsystem.hasAttributes() {
      let info = alertInfoFromSubsystem(subsystem)
      if info.alertState == kEnumSafetySubsystemAlarmALERT {
        if info.alertInfo != nil && info.alertDate != nil {
          let shouldDispay: Bool =
            isNewCountGreaterThanOldCount(presmokePresenter?.alertedDeviceInfo,
                                          new: info.alertInfo)
          configurePresenter(currentPlace,
                             alertInfo: info.alertInfo!,
                             alertDate: info.alertDate!)

          if shouldDispay == true {
            showAlertWithPresenter(presmokePresenter)
          }
        }
      } else if info.alertState == kEnumSafetySubsystemAlarmREADY {
        dismissAlertWithPresenter(presmokePresenter)
        presmokePresenter = nil
      }
    } else {
      dismissAlertWithPresenter(presmokePresenter)
    }
  }

  func isNewCountGreaterThanOldCount(_ old: [[String : AnyObject]]?, new: [[String : AnyObject]]?) -> Bool {
    var isGreater: Bool = true

    if old != nil && new != nil {
      let oldAlertDevices: [DeviceModel]? = old![0]["devices"] as? [DeviceModel]
      let oldCount: Int? = oldAlertDevices!.count

      let newAlertDevices: [DeviceModel]? = new![0]["devices"] as? [DeviceModel]
      let newCount: Int? = newAlertDevices?.count

      isGreater = (newCount! > oldCount!)
    } else if old != nil && new == nil {
      isGreater = false
    }

    return isGreater
  }

  func processExistingAlertEvents() {
    guard SubsystemsController.sharedInstance().safetyController != nil else { return }
    if let safetySubsystem: SubsystemModel = SubsystemsController
      .sharedInstance().safetyController.subsystemModel {
      let info = alertInfoFromSubsystem(safetySubsystem)
      if info.alertState == kEnumSafetySubsystemAlarmALERT {
        if info.alertInfo != nil && info.alertDate != nil {
          configurePresenter(currentPlace,
                             alertInfo: info.alertInfo!,
                             alertDate: info.alertDate!)

          showAlertWithPresenter(presmokePresenter)
        }
      } else if info.alertState == kEnumSafetySubsystemAlarmREADY {
        dismissAlertWithPresenter(presmokePresenter)
      }
    }
  }

  func alertInfoFromSubsystem(_ subsystem: SubsystemModel) ->
    (alertState: String?, alertDate: Date?, alertInfo: [[String : AnyObject]]?) {
      print("")
      let alertType = SafetySubsystemCapability.getSmokePreAlert(from: subsystem)
      var alertDate: Date? = nil
      var alertedDevices: [[String : AnyObject]] = []

      if alertType == kEnumSafetySubsystemAlarmALERT {
        alertDate = SafetySubsystemCapability.getLastSmokePreAlertTime(from: subsystem)
        alertedDevices = alertedDevicesForSubsytem(subsystem)
      }

      return (alertState: alertType,
              alertDate: alertDate,
              alertInfo: alertedDevices)
  }

  func alertedDevicesForSubsytem(_ subsystem: SubsystemModel) -> [[String : AnyObject]] {
    var alertedDevices: [DeviceModel] = []
    if let alertedDeviceAddesses = SafetySubsystemCapability
      .getSmokePreAlertDevices(from: subsystem) as? [String] {

      for address in alertedDeviceAddesses {
        if let device = RxCornea.shared.modelCache?.fetchModel(address) as? DeviceModel {
          alertedDevices.append(device)
        }
      }
    }
    return [["devices": alertedDevices as AnyObject]]
  }

  func configurePresenter(_ placeModel: PlaceModel,
                          alertInfo: [[String : AnyObject]],
                          alertDate: Date) {
    if presmokePresenter == nil {
      presmokePresenter = PresmokeModalAlertPresenter(placeModel: placeModel,
                                                      alertPriority: .high,
                                                      alertedDeviceInfo: alertInfo,
                                                      date: alertDate)
    } else {
      presmokePresenter?.updatePresenterModels(placeModel,
                                               deviceInfo: alertInfo,
                                               date: alertDate)
    }
  }

  // MARK: Convenience Methods

  func presmokeNotifications() -> [String] {
    return [Model.attributeChangedNotification(kAttrSafetySubsystemSmokePreAlert),
            Model.attributeChangedNotification(kAttrSafetySubsystemSmokePreAlertDevices),
            Model.attributeChangedNotification(kAttrSafetySubsystemLastSmokePreAlertTime),
            Model.attributeChangedNotification(kAttrSecuritySubsystemAlarmState),
            Model.attributeChangedNotification(kAttrSafetySubsystemAlarm),
            Model.attributeChangedNotification(kAttrCareSubsystemAlarmState),
            Notification.Name.subsystemInitialized.rawValue,
            kShowPresmokeNotification]
  }
}
