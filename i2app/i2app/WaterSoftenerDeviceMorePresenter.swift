//
//  WaterSoftenerDeviceMorePresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/14/17.
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

extension Notification.Name {

}

/*
 `WaterSoftenerMorePresenter` class conforms to `DeviceMorePresenter` and is used to display the options for
 Device Operation -> More for the WaterSoftener.
 **/
class WaterSoftenerMorePresenter: DeviceMorePresenter, BatchNotificationObserver {
  weak var delegate: DeviceMorePresenterDelegate?
  var device: DeviceModel

  var moreItems: [DeviceMoreItemViewModel] {
    return [DeviceMoreItem("Wi-Fi & Network",
                           description: "If this device is connected to the incorrect Wi-Fi network, " +
                                        "please update it on the device.",
                           info: "Test",
                           actionType: .none,
                           actionIdentifier: "",
                           cellIdentifier: "DeviceMoreInfoCell",
                           metaData: nil),
            DeviceMoreItem("Favorites",
                           description: "Add to Favorites",
                           info: nil,
                           actionType: .toggle,
                           actionIdentifier: "AddToFavorites",
                           cellIdentifier: "DeviceMoreSwitchCell",
                           metaData: ["toggleState": isFavorite() as AnyObject]),
            DeviceMoreItem(device.name,
                           description: "Edit Name & Photo",
                           info: nil,
                           actionType: .segue,
                           actionIdentifier: "EditNamePhotoSegue",
                           cellIdentifier: "DeviceMoreDisclosureCell",
                           metaData: nil),
            DeviceMoreItem("Recharge Now",
                           description: "Manually Recharge Your Water Softener",
                           info: nil,
                           actionType: .segue,
                           actionIdentifier: "WaterSoftenerRechargeNowSegue",
                           cellIdentifier: "DeviceMoreDisclosureCell",
                           metaData: nil),
            DeviceMoreItem("Recharge Time",
                           description: "Set the Recharge Time",
                           info: nil,
                           actionType: .segue,
                           actionIdentifier: "WaterSoftenerRechargeTimeSegue",
                           cellIdentifier: "DeviceMoreDisclosureCell",
                           metaData: nil),
            DeviceMoreItem("Water Hardness Level",
                           description: "Edit Your Water Hardness",
                           info: nil,
                           actionType: .segue,
                           actionIdentifier: "WaterSoftenerWaterHardnessSegue",
                           cellIdentifier: "DeviceMoreDisclosureCell",
                           metaData: nil),
            DeviceMoreItem("Salt Type",
                           description: "Recommendations",
                           info: nil,
                           actionType: .segue,
                           actionIdentifier: "WaterSoftenerSaltTypeSegue",
                           cellIdentifier: "DeviceMoreDisclosureCell",
                           metaData: nil),
            DeviceMoreItem("Water Flow",
                           description: "Manage Water Flow Notifications",
                           info: nil,
                           actionType: .segue,
                           actionIdentifier: "WaterSoftenerWaterFlowSegue",
                           cellIdentifier: "DeviceMoreDisclosureCell",
                           metaData: nil),
            DeviceMoreItem("Product Information",
                           description: "Model Number, Purchase Date & More",
                           info: nil,
                           actionType: .segue,
                           actionIdentifier: "ProductInfoSegue",
                           cellIdentifier: "DeviceMoreDisclosureCell",
                           metaData: nil)]
  }

  required init(_ delegate: DeviceMorePresenterDelegate?,
                device: DeviceModel) {
    self.delegate = delegate
    self.device = device

    observeBatchNotifications(deviceNotifications(), selector: #selector(deviceUpdated(_:)))
  }

  func deviceNotifications() -> [Notification.Name] {
    return [Notification.Name(rawValue: "UpdateDeviceModelNotification")]
  }

  deinit {
    removeAllBatchNotificationObservers()
  }

  func performAction(_ viewModel: DeviceMoreItemViewModel) {
    if viewModel.actionType == .segue {
      delegate?.performSegue(viewModel.actionIdentifier)
    } else if viewModel.actionType == .popup {
      // No actions currently use .popup.
    } else if viewModel.actionType == .toggle && viewModel.actionIdentifier == "AddToFavorites"{
      toggleFavorite()
    }
  }

  @objc func deviceUpdated(_ notification: Notification) {
    if let address = device.address as String?,
      let model = RxCornea.shared.modelCache?.fetchModel(address) as? DeviceModel {
      device = model
    }
    delegate?.updateLayout()
  }

  func onRemoveDevicePressed() {
    delegate?.displayRemovePopup()
  }

  func removeDevice() {
    if let viewController = DeviceUnpairingManager.sharedInstance().startRemovingDevice(device) {
      delegate?.present(viewController)
    }
  }

  func prepareDesination(_ viewController: UIViewController) {
    if let vc = viewController as? WaterSoftenerRechargeNowController {
      vc.deviceModel = device
    } else if let vc = viewController as? WaterSoftenerRechargeTimeController {
      vc.deviceModel = device
    } else if let vc = viewController as? WaterSoftenerWaterHardnessLvController {
      vc.deviceModel = device
    } else if let vc = viewController as? WaterSoftenerWaterFlowViewController {
      vc.presenter = WaterSoftenerWaterFlowPresenter(vc, device: device)
    }
  }
}
