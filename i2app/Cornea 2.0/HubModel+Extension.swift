//
//  HubModel+Extension.swift
//  i2app
//
//  Created by Arcus Team on 9/29/17.
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

fileprivate struct AssociatedKeys {
  static var kOperationsControllerKey: UInt8 = 0
}

extension HubModel {
  // MARK: DeviceType

  var deviceType: DeviceType {
    return .hub
  }

  override public var name: String {
    if let hubName = HubCapabilityLegacy.getName(self) {
      if hubName.count > 0 {
        return hubName
      }
    }
    return "HUB"
  }

  var isDeviceOffline: Bool {
    if let state = DeviceConnectionCapabilityLegacy.getState(DeviceModel(attributes: get())) {
      return state == kEnumDeviceConnectionStateOFFLINE
    }
    return false
  }

  var productId: String? {
    return ""
  }

  var vendor: String? {
    return HubCapabilityLegacy.getVendor(self)
  }

  var backgroundImageName: String {
    return ""
  }

  var devTypeHintToImageName: String {
    return "hub"
  }

  var viewControllerClass: AnyClass? {
    return NSClassFromString("HubOperationViewController")
  }

  var operationController: DeviceOperationBaseController? {
    get {
      guard let controller = objc_getAssociatedObject(self,
                                                      &AssociatedKeys.kOperationsControllerKey)
        as? DeviceOperationBaseController else {
          return nil
      }
      return controller
    }
    set {
      objc_setAssociatedObject(self,
                               &AssociatedKeys.kOperationsControllerKey,
                               newValue,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  var lastChange: Date? {
    return HubConnectionCapabilityLegacy.getLastchange(self)
  }

  var isRunningOnBattery: Bool {
    if let batteryState = HubPowerCapability.getSourceFrom(self) {
      if batteryState.count > 0 {
        return batteryState == kEnumHubPowerSourceBATTERY
      }
    }
    return false
  }

  var isDown: Bool {
    if let hubState = HubCapability.getStateFrom(self) {
      if hubState.count > 0 {
        return hubState == kEnumHubStateDOWN
      }
    }
    return true
  }

  // LEGACY COMMENT:
  // Per conversation with Ted, HubModel has no way of telling us if the hub is in firmware upgrade
  // If the hub is in firmware upgrade, it will be DOWN and the isDown method will take care of the
  // Online/Offline state
  var isUpdateingFirmware: Bool {
    return false
  }
}
