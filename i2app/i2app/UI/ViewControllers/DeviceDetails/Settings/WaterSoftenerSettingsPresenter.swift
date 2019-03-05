//
//  WaterSoftenerSettingsPresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/19/17.
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

/*
 `WaterSoftenerSettingPresenter` defines the expected properties of a presenter used by a `UIViewController` for WaterSoftener Settings.
 **/
protocol WaterSoftenerSettingPresenter {
  weak var delegate: WaterSoftenerSettingPresenterDelegate? { get set }

  var device: DeviceModel { get set }
  var settingItems: [DeviceMoreItemViewModel] { get }

  /**
   Used to update the presenter when the device is updated.

   - Parameter notification: The received `Notification`
   */
  func deviceUpdated(_ notification: Notification)

  /**
   Toggle the alert for excessive flow.

   - Parameter excessive: Bool indicating if alerts should be on or off.
   */
  func toggle(_ excessive: Bool)
}

/*
 `WaterSoftenerSettingPresenterDelegate` defines the expected behavior of a class that implements `WaterSoftenerSettingPresenter`
 **/
protocol WaterSoftenerSettingPresenterDelegate: class {
  /**
   Used to update the layout of WaterSoftenerSettingPresenterDelegate.
   */
  func updateLayout()
}

class WaterSoftenerWaterFlowPresenter: WaterSoftenerSettingPresenter,
  EcoWaterController,
BatchNotificationObserver {
  weak var delegate: WaterSoftenerSettingPresenterDelegate?
  var device: DeviceModel

  var settingItems: [DeviceMoreItemViewModel] {
    return [WaterSoftenerSettingViewModel("Continuous Water Flow",
                                          description: "Choose the flow rate that will "
                                            + "trigger a push notification and an email "
                                            + "when the flow rate has been reached for "
                                            + "20 minutes.",
                                          info: continuousValue(),
                                          actionType: .popup,
                                          actionIdentifier: "ContinuousWaterFlowPopup",
                                          cellIdentifier: "WaterFlowInfoCell",
                                          metaData: nil),
            WaterSoftenerSettingViewModel("Excessive Water Flow",
                                          description: "This device learns your average "
                                            + "daily water usuage.  If the amount of  "
                                            + "water used in a particular day is "
                                            + "significantly more than average for that "
                                            + "day of the week, send a high water use "
                                            + "push notification and email to "
                                            + accountOwner(),
                                          info: nil,
                                          actionType: .toggle,
                                          actionIdentifier: "ExcessiveFlowToggle",
                                          cellIdentifier: "WaterFlowSwitchCell",
                                          metaData: ["toggleState": isExcessive() as AnyObject])]
  }

  required init(_ delegate: WaterSoftenerSettingPresenterDelegate?,
                device: DeviceModel) {
    self.delegate = delegate
    self.device = device

    observeBatchNotifications(deviceNotifications(), selector: #selector(deviceUpdated(_:)))
  }

  func deviceNotifications() -> [Notification.Name] {
    return [
      Notification.Name(rawValue: "UpdateDeviceModelNotification"),
      Notification.Name.subsystemInitialized
    ]
  }

  deinit {
    removeAllBatchNotificationObservers()
  }

  @objc func deviceUpdated(_ notification: Notification) {
    if let address = device.address as String?,
      let model = RxCornea.shared.modelCache?.fetchModel(address) as? DeviceModel {
      device = model
      delegate?.updateLayout()
    }
  }

  func continuousValue() -> String {
    let rate = getContinuousRate(device)
    switch rate {
    case 0.3:
      return "Low"
    case 2.0:
      return "Medium"
    case 8.0:
      return "High"
    default:
      return "Off"
    }
  }

  func accountOwner() -> String {
    let currentAccount = RxCornea.shared.settings?.currentAccount
    if let ownerId = AccountCapability.getOwnerFrom(currentAccount) {
      let address = PersonModel.addressForId(ownerId)
      if let ownerModel = RxCornea.shared.modelCache?.fetchModel(address) as? PersonModel {
        if let firstName = ownerModel.firstName {
          return firstName
        }
      } else {
        return NSLocalizedString("the account owner.", comment: "")
      }
    }
    return ""
  }

  func toggle(_ excessive: Bool) {
    DispatchQueue.global(qos: .background).async {
      _ = self.setExcessiveFlow(self.device, alert: excessive)
    }
  }

  func isExcessive() -> Bool {
    return getIsAlertingExcessiveFlow(device)
  }
}
