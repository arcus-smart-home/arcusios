//
//  KitSetupHelper.swift
//  i2app
//
//  Created by Arcus Team on 7/27/18.
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

enum KitSetupDeviceState {
  case inactive
  case activated
  case activatedAndCustomized
  case improperlyPaired
  case missing
}

protocol KitSetupHelper: ArcusDeviceAdvancedCapability, ArcusPairingDeviceCapability {
  
  // MARK: Extended
  
  func deviceState(pairingDevices: [PairingDeviceModel], protocolAddress: String) -> KitSetupDeviceState
  
  func deviceModel(forProtocolAddress protocolAddress: String) -> DeviceModel?
}

extension KitSetupHelper{
  
  func deviceState(pairingDevices: [PairingDeviceModel], protocolAddress: String) -> KitSetupDeviceState {
    let device = deviceModel(forProtocolAddress: protocolAddress)
    let pairDeviceModel = pairDevice(fromPairDevices: pairingDevices, protocolAddress: protocolAddress)
    
    // If there is no device model for the current kit device, then the kit device has not been activated,
    // or it is currently in an error state.
    if device == nil {
      if let pairDevice = pairDeviceModel,
        let pairingState = getPairingDevicePairingState(pairDevice) {
        
        if pairingState == .misconfigured || pairingState == .mispaired {
          return .improperlyPaired
        } else if pairingState == .pairing {
          return .inactive
        }
      } else {
        return .missing
      }
    }
    
    // If there is a device model then the pairing phase of the pair device model should dictate
    // the state of the kit device.
    if let pairDevice = pairDeviceModel,
      let pairingState = getPairingDevicePairingState(pairDevice) {
      
      if pairingState == .mispaired || pairingState == .misconfigured  {
        return .improperlyPaired
      } else {
        if let customizations = getPairingDeviceCustomizations(pairDevice),
          customizations.contains(PairingCustomizationStepType.complete.rawValue) {
          return .activatedAndCustomized
        } else {
          return .activated
        }
      }
    } else {
      return .activatedAndCustomized
    }
  }
  
  func deviceModel(forProtocolAddress protocolAddress: String) -> DeviceModel? {
    let namespace = Constants.deviceNamespace
    
    guard let protocolIdFromAddress = protocolId(fromProtocolAddress: protocolAddress),
      let deviceModels = RxCornea.shared.modelCache?.fetchModels(namespace) as? [DeviceModel] else {
        return nil
    }
    
    for deviceModel in deviceModels {
      if let protocolId = getDeviceAdvancedProtocolid(deviceModel), protocolId == protocolIdFromAddress {
        return deviceModel
      }
    }
    
    return nil
  }
  
  func pairDevice(fromPairDevices pairDevices: [PairingDeviceModel],
                  protocolAddress: String) -> PairingDeviceModel? {
    for pairDevice in pairDevices where getPairingDeviceProtocolAddress(pairDevice) == protocolAddress {
      return pairDevice
    }
    
    return nil
  }

  private func protocolId(fromProtocolAddress protocolAddress: String) -> String? {
    let protocolAddressParts = protocolAddress.components(separatedBy: ":")
    
    if protocolAddressParts.count > 2 {
      return protocolAddressParts.last
    }
    
    return nil
  }

  
}
