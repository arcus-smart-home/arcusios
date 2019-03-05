//
//  SecurityModePresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/29/18.
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
import RxSwift
import Cornea

enum DeviceSecurityMode {
  case on
  case partial
  case onAndPartial
  case notParticipating
}

protocol SecurityModePresenter: class {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   Required by RxSwift to track observables.
   */
  var disposeBag: DisposeBag { get }
  
  /**
   The data for the security mode choices available for the current device.
   */
  var securityModeChoices: [SecurityModeChoiceViewModel] { get set }
  
  /**
   Called whenever there is a chage in the choices available.
   */
  func securityModeDataUpdated()
  
  // MARK: Extended
  
  /**
   Saves the currect selection to the platform
   */
  func securityModeSaveData()
  
  /**
   Retrieves the current security mode state for the device.
   */
  func securityModeFetchData()
  
}

extension SecurityModePresenter {
  
  func securityModeSaveData() {
    for choice in securityModeChoices where choice.isSelected {
      save(type: choice.type)
      break
    }
  }
  
  func securityModeFetchData() {
    guard let model = deviceModel() else {
      return
    }

    var onChoice = choiceOn()
    var partialChoice = choicePartial()
    var onAndPartialChoice = choiceOnAndPartial()
    var notParticipatingChoice = choiceNotParticipating()
    
    switch model.securityModeStatus().lowercased() {
    case "on & partial":
      onAndPartialChoice.isSelected = true
    case "on":
      onChoice.isSelected = true
    case "partial":
      partialChoice.isSelected = true
    default:
      notParticipatingChoice.isSelected = true
    }
    
    securityModeChoices = [onAndPartialChoice, onChoice, partialChoice, notParticipatingChoice]
    securityModeDataUpdated()
  }
  
  private func save(type: DeviceSecurityMode) {
    switch type {
    case .on:
      removeDevice(fromSecurityMode: .partial)
      addDevice(toSecurityMode: .on)
    case .partial:
      removeDevice(fromSecurityMode: .on)
      addDevice(toSecurityMode: .partial)
    case .onAndPartial:
      addDevice(toSecurityMode: .on)
      addDevice(toSecurityMode: .partial)
    case .notParticipating:
      removeDevice(fromSecurityMode: .on)
      removeDevice(fromSecurityMode: .partial)
      break
    }
  }
  
  private func choiceOn() -> SecurityModeChoiceViewModel {
    return SecurityModeChoiceViewModel(
      title: "On",
      description: "Ideal when no one is home, and you wish to secure your entire home.",
      type: .on,
      isSelected: false)
  }
  
  private func choicePartial() -> SecurityModeChoiceViewModel {
    return SecurityModeChoiceViewModel(
      title: "Partial",
      description: "Typically used when motion sensors are not participating so you can move around the" +
      " home at night without triggering the alarm.",
      type: .partial,
      isSelected: false)
  }
  
  private func choiceOnAndPartial() -> SecurityModeChoiceViewModel {
    return SecurityModeChoiceViewModel(
      title: "On & Partial",
      description: "Device participates in both ON & Partial Modes.",
      type: .onAndPartial,
      isSelected: false)
  }
  
  private func choiceNotParticipating() -> SecurityModeChoiceViewModel {
    return SecurityModeChoiceViewModel(
      title: "Not Participating",
      description: "Devices will not participate in your Security Alarm system.",
      type: .notParticipating,
      isSelected: false)
  }
  
  private func removeDevice(fromSecurityMode mode: DeviceSecurityMode) {
    guard let device = deviceModel(),
      let subsystemController = SubsystemsController.sharedInstance().securityController else {
      return
    }
    
    var deviceAddresses = getModeDevices(forMode: mode)
    
    if let indexToRemove = deviceAddresses.index(of: device.address) {
      deviceAddresses.remove(at: indexToRemove)

      if mode == .on {
        subsystemController.setModeONDevices(deviceAddresses)
      } else if mode == .partial {
        subsystemController.setModePARTIALDevices(deviceAddresses)
      }
    }
  }
  
  private func addDevice(toSecurityMode mode: DeviceSecurityMode) {
    guard let subsystemController = SubsystemsController.sharedInstance().securityController,
      let device = deviceModel() else {
        return
    }
    
    var deviceAddresses = getModeDevices(forMode: mode)
 
    if deviceAddresses.index(of: device.address) == nil {
      deviceAddresses.append(device.address)

      if mode == .on {
        subsystemController.setModeONDevices(deviceAddresses)
      } else if mode == .partial {
        subsystemController.setModePARTIALDevices(deviceAddresses)
      }
    }
  }
  
  private func getModeDevices(forMode mode: DeviceSecurityMode) -> [String] {
    guard let subsystemController = SubsystemsController.sharedInstance().securityController else {
        return [String]()
    }
    
    var deviceAddresses = [String]()
    if mode == .on {
      if let devices = subsystemController.modeONDevices as? [String] {
        deviceAddresses = devices
      }
    } else if mode == .partial {
      if let devices = subsystemController.modePARTIALDevices as? [String] {
        deviceAddresses = devices
      }
    }
    return deviceAddresses
  }
  
  private func securityAlarmSubsystem() -> SubsystemModel? {
    guard let cache = RxCornea.shared.modelCache,
      let models = cache.fetchModels(Constants.securitySubsystemNamespace) as? [SubsystemModel],
      models.count > 0 else {
        return nil
    }
    
    return models[0]
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
