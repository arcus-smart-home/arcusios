//
//  WeatherAlertController.swift
//  i2app
//
//  Created by Arcus Team on 11/8/16.
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

import UIKit
import Cornea

let kShowWeatherNotification: String = "ShowWeatherModalAlert"
extension Notification.Name {
  static let ShowWeather = Notification.Name("ShowWeatherModalAlert")
}
let kWeatherAlertTitleTemplate: String = "<weatherAlertName> Issued at <time> on <date>"

class WeatherAlertController: AlertController, AlertControllerProtocol, HaloEasCodesPresenterDelegate {
  var weatherPresenter: WeatherModalAlertPresenter?
  var easCodes: [EasCode]?

  // MARK: Life Cycle

  required init(delegate: AlertControllerDelegate, currentPlace: PlaceModel) {
    super.init(delegate: delegate, currentPlace: currentPlace)
    observeAlertNotifications(weatherAlertNotifications(),
                              selector: #selector(alertNotificationReceived(_:)))
    HaloEasCodesPresenter.getEasCodes(self)
  }

  deinit {
    removeAllAlertNotificationObservers()
  }

  // MARK: Notification Response Handling

  func alertNotificationReceived(_ notification: Notification) {
    preventAlertDisplay = processPriorityAlarm()
    if preventAlertDisplay != true {
      if notification.name == Model
        .attributeChangedNotificationName(kAttrWeatherSubsystemWeatherAlert) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrWeatherSubsystemAlertingRadios) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrWeatherSubsystemLastWeatherAlertTime) {
        processAlertEvent(notification)
      } else if notification.name == Notification.Name.subsystemInitialized ||
        notification.name == Notification.Name.ShowWeather ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrSecuritySubsystemAlarmState) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrSafetySubsystemAlarm) ||
        notification.name == Model
          .attributeChangedNotificationName(kAttrCareSubsystemAlarmState) {
        processExistingAlertEvents()
      }
    } else {
      dismissAlertWithPresenter(weatherPresenter)
    }
  }

  func processAlertEvent(_ notification: Notification) {
    if let subsystem = notification.userInfo?["Model"] as? SubsystemModel {
      let info = alertInfoFromSubsystem(subsystem)
      if info.alertState == kEnumWeatherSubsystemWeatherAlertALERT {
        if info.alertInfo != nil && info.alertDate != nil {
          let shouldDispay: Bool =
            isNewCountGreaterThanOldCount(weatherPresenter?.alertedDeviceInfo,
                                          new: info.alertInfo)

          configurePresenter(currentPlace,
                             alertInfo: info.alertInfo!,
                             alertDate: info.alertDate!)

          if shouldDispay == true {
            showAlertWithPresenter(weatherPresenter)
          }
        }
      } else if info.alertState == kEnumWeatherSubsystemWeatherAlertREADY {
        dismissAlertWithPresenter(weatherPresenter)
        weatherPresenter = nil
      }
    } else {
      dismissAlertWithPresenter(weatherPresenter)
    }
  }

  func isNewCountGreaterThanOldCount(_ old: [[String : AnyObject]]?, new: [[String : AnyObject]]?) -> Bool {
    var isGreater: Bool = true

    if old != nil && new != nil {
      if old!.count == new!.count {
        var groupIsGreater = false
        for newAlertInfo: [String : AnyObject] in new! {
          let newAlertTitle: String? = newAlertInfo["alertTitle"] as? String
          let newAlertDevices: [DeviceModel]? = newAlertInfo["devices"] as? [DeviceModel]
          let newCount: Int? = newAlertDevices!.count

          for oldAlertInfo: [String : AnyObject] in old! {
            let oldAlertTitle: String? = oldAlertInfo["alertTitle"] as? String
            if oldAlertTitle == newAlertTitle {
              let oldAlertDevices: [DeviceModel]? = oldAlertInfo["devices"] as? [DeviceModel]
              let oldCount: Int? = oldAlertDevices?.count

              if newCount != nil && oldCount != nil {
                if newCount! > oldCount! {
                  groupIsGreater = true
                  break
                }
              }
            }
          }

          if groupIsGreater == true {
            break
          }
        }
        isGreater = groupIsGreater
      }
    } else if old != nil && new == nil {
      isGreater = false
    }

    return isGreater
  }

  func processExistingAlertEvents() {
    guard SubsystemsController.sharedInstance().weatherSubsystemController != nil else { return }
    let weatherSubsystem: SubsystemModel? = SubsystemsController.sharedInstance()
      .weatherSubsystemController.subsystemModel
    if weatherSubsystem != nil {
      let info = alertInfoFromSubsystem(weatherSubsystem!)
      if info.alertState == kEnumWeatherSubsystemWeatherAlertALERT {
        if info.alertInfo != nil && info.alertDate != nil {
          configurePresenter(currentPlace,
                             alertInfo: info.alertInfo!,
                             alertDate: info.alertDate!)

          showAlertWithPresenter(weatherPresenter)
        }
      } else if info.alertState == kEnumWeatherSubsystemWeatherAlertREADY {
        dismissAlertWithPresenter(weatherPresenter)
      }
    }
  }

  func alertInfoFromSubsystem(_ subsystem: SubsystemModel) ->
    (alertState: String?, alertDate: Date?, alertInfo: [[String : AnyObject]]?) {

      let alertType = WeatherSubsystemCapability.getWeatherAlert(from: subsystem)
      var alertDate: Date? = nil
      var alertedDevices: [[String : AnyObject]] = []

      if alertType == kEnumSafetySubsystemAlarmALERT {
        alertDate = WeatherSubsystemCapability.getLastWeatherAlertTime(from: subsystem)
        alertedDevices = alertedDevicesForSubsytem(subsystem)
      }

      return (alertState: alertType,
              alertDate: alertDate,
              alertInfo: alertedDevices)
  }

  func alertedDevicesForSubsytem(_ subsystem: SubsystemModel) -> [[String : AnyObject]] {
    var alertedDevices: [[String : AnyObject]] = []

    let alertDate: Date = WeatherSubsystemCapability.getLastWeatherAlertTime(from: subsystem)

    if let alertedDeviceInfo = WeatherSubsystemCapability
      .getAlertingRadios(from: subsystem) as? [String: [String]] {
      for (easCode, deviceInfo) in alertedDeviceInfo {
        var alertTitle: String = "Unknown"
        if let easName: String = easCodeName(easCode) {
          alertTitle = weatherAlertStringForAlertName(easName, alertDate: alertDate)
        }

        var deviceModels: [DeviceModel] = []
        for deviceAddress in deviceInfo {
          if let device = RxCornea.shared.modelCache?
            .fetchModel(deviceAddress) as? DeviceModel {
            deviceModels.append(device)
          }
        }

        let result: [String : AnyObject] = ["alertTitle": alertTitle as AnyObject,
                                            "devices": deviceModels as AnyObject]
        alertedDevices.append(result)
      }
    }

    return alertedDevices
  }

  func configurePresenter(_ placeModel: PlaceModel,
                          alertInfo: [[String : AnyObject]],
                          alertDate: Date) {
    if weatherPresenter == nil {
      weatherPresenter = WeatherModalAlertPresenter(placeModel: placeModel,
                                                    alertPriority: .normal,
                                                    alertedDeviceInfo: alertInfo,
                                                    date: alertDate)
    } else {
      weatherPresenter?.updatePresenterModels(placeModel,
                                              deviceInfo: alertInfo,
                                              date: alertDate)
    }
  }

  // MARK: HaloEasCodesPresenterDelegate

  func getEasCodes(_ states: [EasCode]) {
    easCodes = states
  }

  // MARK: Convenience Methods

  func weatherAlertNotifications() -> [String] {
    return [Model.attributeChangedNotification(kAttrWeatherSubsystemWeatherAlert),
            Model.attributeChangedNotification(kAttrWeatherSubsystemAlertingRadios),
            Model.attributeChangedNotification(kAttrWeatherSubsystemLastWeatherAlertTime),
            Model.attributeChangedNotification(kAttrSecuritySubsystemAlarmState),
            Model.attributeChangedNotification(kAttrSafetySubsystemAlarm),
            Model.attributeChangedNotification(kAttrCareSubsystemAlarmState),
            Notification.Name.subsystemInitialized.rawValue,
            kShowWeatherNotification]
  }

  func easCodeName(_ code: String) -> String? {
    var result: String?
    if easCodes != nil {
      for easCode in easCodes! where easCode.easCode == code {
        result = easCode.name
        break
      }
    }
    return result
  }

  func weatherAlertStringForAlertName(_ name: String, alertDate: Date) -> String {
    var alertString: String = kWeatherAlertTitleTemplate
    alertString = alertString.replacingOccurrences(of: "<weatherAlertName>", with: name)

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = "h:mm a"

    let timeString: String = dateFormatter.string(from: alertDate)
    alertString = alertString.replacingOccurrences(of: "<time>", with: timeString)

    dateFormatter.dateFormat = "MMM dd, YYYY"

    let dayString = dateFormatter.string(from: alertDate)
    alertString = alertString.replacingOccurrences(of: "<date>", with: dayString)

    return alertString
  }
}
