//
//  KitDeviceDismissHelper.swift
//  i2app
//
//  Created by Arcus Team on 8/22/18.
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

import RxSwift
import Cornea

class KitDeviceDismissHelper: ArcusPairingDeviceCapability {
  var disposeBag = DisposeBag()
  
  static func dismissKittedDevicesIfNeeded() {
    guard let pairDevices = pairingDeviceModels() else {
      return
    }
    
    for pairDevice in pairDevices {
      if isDeviceKitted(pairDevice) && isDevicePaired(pairDevice) {
        do {
          _ = try KitDeviceDismissHelper().requestPairingDeviceDismiss(pairDevice)
        } catch {
          DDLogError("Error - error dismissing paired kit device.")
        }
      }
    }
  }
  
  private static func isDeviceKitted(_ pairDevice: PairingDeviceModel) -> Bool {
    if let tags = pairDevice.getTags() as? [String] {
      for tag in tags where tag.uppercased() == "KIT" {
        return true
      }
    }
    
    return false
  }
  
  private static func isDevicePaired(_ pairDevice: PairingDeviceModel) -> Bool {
    guard let state = KitDeviceDismissHelper().getPairingDevicePairingState(pairDevice) else {
      return false
    }
    
    return state == .paired
  }
  
  private static func pairingDeviceModels() -> [PairingDeviceModel]? {
    let namespace = Constants.pairingDeviceNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [PairingDeviceModel] else {
      return nil
    }
    
    return models
  }
  
}
