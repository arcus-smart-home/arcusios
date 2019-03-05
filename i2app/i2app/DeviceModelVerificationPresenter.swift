//
//  DeviceModelVerificationPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/19/18.
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
import UIKit

/// When a device is selected these verifications can be returned
enum DeviceModelVerification {
  case hubRequired
  case hubOffline
  case requiredClientVersion
  case deviceRequired(String)
  case mayContinue

  /// A mapping to segues
  var segueIdentifier: String {
    switch self {
    case .hubRequired:
      return PairingCatalogSegue.showHubRequired.rawValue
    case .hubOffline:
      return PairingCatalogSegue.showHubOffline.rawValue
    case .requiredClientVersion:
      return PairingCatalogSegue.showRequiredClientVersion.rawValue
    case .deviceRequired(_):
      return PairingCatalogSegue.showDeviceRequired.rawValue
    case .mayContinue:
      return PairingCatalogSegue.showPairingInstructions.rawValue
    }
  }
}

/// View Controllers can conform to this class to handle the shared logic of presenting a
/// CatalogDeviceViewModel. Search and Device List both need to share this logic
protocol DeviceModelVerificationPresenter: ArcusDeviceCapability {
  /**
   Called when a view model is selected
   Hub Model should have a default value
   This is extended and not intended to be overridden
   */
  func didSelect(deviceViewModel: CatalogDeviceViewModel,
                 currentHub: HubModel?,
                 modelCache: (ArcusModelCache & RxSwiftModelCache)?) -> DeviceModelVerification
}

extension DeviceModelVerificationPresenter {

  /// static helper function to clean up the next function default param for cache
  private static func optionalModelCache() -> (ArcusModelCache & RxSwiftModelCache)? {
    if let cache = RxCornea.shared.modelCache as? (ArcusModelCache & RxSwiftModelCache) {
      return cache
    }
    return nil
  }

  /// helper function to get all DeviceModels from the model cache
  func allDevices(_ modelCache: (ArcusModelCache & RxSwiftModelCache)?) -> [DeviceModel]? {
    if let devices = modelCache?.fetchModels(Constants.deviceNamespace) as? [DeviceModel] {
      return devices
    }
    return nil
  }

  /**
   Called when a view model is selected
   Hub Model has a default value of `RxCornea.shared.settings?.currentHub` and be only used in testing
   */
  func didSelect(deviceViewModel: CatalogDeviceViewModel,
                 currentHub: HubModel? = RxCornea.shared.settings?.currentHub,
                 modelCache: (ArcusModelCache & RxSwiftModelCache)? = Self.optionalModelCache()) -> DeviceModelVerification {
    if deviceViewModel.hubRequired == true {
      if let currentHub = currentHub {
        if currentHub.isDown {
          return .hubOffline
        }
      } else {
        //present hub required
        return .hubRequired
      }
    }
    if let deviceRequired = deviceViewModel.deviceRequired {

      // a list of devices with this product ID
      var devices = allDevices(modelCache) ?? []
      devices = devices.filter { aDevice -> Bool in
        return getDeviceProductId(aDevice) == deviceRequired
      }
      // check that a device exist of the correct type
      if devices.count == 0 {
        return .deviceRequired(deviceRequired)
      }
      return .mayContinue
    }

    if let minAppVersion = deviceViewModel.minAppVersion,
      let clientVersion = BuildConfigure.clientVersion() {
      if clientVersion.isVersion(lessThan: minAppVersion) {
        return .requiredClientVersion
      }
    }
    
    // all clear, display the first step
    return .mayContinue
  }
}

/// Humble Extension of DeviceModelVerificationPresenter that handles shared View Controller logic
extension DeviceModelVerificationPresenter where Self: UIViewController {

  /// This is where View Controllers can use the shared logic of the DeviceModelVerificationPresenter
  /// - warning: Conforming View Controllers must correctly implement the expected segues
  func verify(deviceViewModel: CatalogDeviceViewModel) {
    let nextStep = didSelect(deviceViewModel: deviceViewModel)
    let segue = PairingCatalogSegue.segueFor(deviceModelVerification: nextStep)
    if self.shouldPerformSegue(withIdentifier: segue.rawValue, sender: deviceViewModel) {
      self.performSegue(withIdentifier: segue.rawValue, sender: deviceViewModel)
    }
  }
}
