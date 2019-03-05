//
//  AlarmDeviceModePresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/22/17.
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

enum AlarmDeviceModeType {
  case onAndPartial
  case on
  case partial
  case notParticipating
}

private enum DeviceModeTitle {
  static let onPartial = NSLocalizedString("ON & PARTIAL", comment: "")
  static let on = NSLocalizedString("ON", comment: "")
  static let partial = NSLocalizedString("PARTIAL", comment: "")
  static let notParticipating = NSLocalizedString("NOT PARTICIPATING", comment: "")
}

protocol AlarmDeviceModePresenterProtocol {
  weak var delegate: AlarmDeviceModePresenterDelegate? { get set }
  var deviceModes: [AlarmDeviceModeViewModel] { get set }

  func navigationTitle() -> String
  func selectModeAtIndex(_ index: Int)
}

protocol AlarmDeviceModePresenterDelegate: class {
  var deviceAddress: String { get set }

  func shouldUpdateViews()
}

class AlarmDeviceModePresenter {
  weak var delegate: AlarmDeviceModePresenterDelegate?
  var deviceModel = DeviceModel()
  var deviceModes = [AlarmDeviceModeViewModel]()

  init(delegate: AlarmDeviceModePresenterDelegate, deviceAddress: String) {
    self.delegate = delegate

    populateDeviceModes(deviceAddress)
  }

  fileprivate func populateDeviceModes(_ deviceAddress: String) {
    guard let model = RxCornea.shared.modelCache?.fetchModel(deviceAddress) as?
      DeviceModel else {
        return
    }

    deviceModel = model
    deviceModes = [AlarmDeviceModeViewModel]()

    deviceModes.append(AlarmDeviceModeViewModel(type: .onAndPartial,
      isSelected: false))
    deviceModes.append(AlarmDeviceModeViewModel(type: .on,
      isSelected: false))
    deviceModes.append(AlarmDeviceModeViewModel(type: .partial,
      isSelected: false))
    deviceModes.append(AlarmDeviceModeViewModel(type: .notParticipating,
      isSelected: false))

    selectDeviceModeForModel()
  }

  fileprivate func selectDeviceModeForModel() {
    let modeFromModel = deviceModel.securityModeStatus()
    var selectedMode = AlarmDeviceModeType.onAndPartial

    if modeFromModel == "On & Partial" {
      selectedMode = .onAndPartial
    } else if modeFromModel == "Partial" {
      selectedMode = .partial
    } else if modeFromModel == "On" {
      selectedMode = .on
    } else if modeFromModel == "Not Participating" {
      selectedMode = .notParticipating
    }

    for mode in deviceModes {
      if mode.type == selectedMode {
        mode.isSelected = true
      } else {
        mode.isSelected = false
      }
    }
  }

  fileprivate func changeDeviceModelToMode(_ mode: AlarmDeviceModeType) {
    DispatchQueue.global(qos: .background).async {
      switch mode {
      case .notParticipating:
        self.removeDeviceFromOn()
        self.removeDeviceFromPartial()
      case .onAndPartial:
        self.removeDeviceFromOn()
        self.removeDeviceFromPartial()
        self.addDeviceToOn()
        self.addDeviceToPartial()
      case .on:
        self.removeDeviceFromOn()
        self.removeDeviceFromPartial()
        self.addDeviceToOn()
      case .partial:
        self.removeDeviceFromOn()
        self.removeDeviceFromPartial()
        self.addDeviceToPartial()
      }
    }
  }

  fileprivate func removeDeviceFromOn() {
    if var onDevices = SubsystemsController.sharedInstance().securityController.modeONDevices as? [Any] {
      var indexToRemove: Int?

      for (index, device) in (onDevices.enumerated()) where device as? String == delegate?.deviceAddress {
        indexToRemove = index
      }

      if indexToRemove != nil {
        onDevices.remove(at: indexToRemove!)
      }

      SubsystemsController.sharedInstance().securityController.setModeONDevices(onDevices)
    }
  }

  fileprivate func removeDeviceFromPartial() {
    if var partialDevices =
      SubsystemsController.sharedInstance().securityController.modePARTIALDevices as? [Any] {

      var indexToRemove: Int?

      for (index, device) in (partialDevices.enumerated())
        where device as? String == delegate?.deviceAddress {

          indexToRemove = index
      }

      if indexToRemove != nil {
        partialDevices.remove(at: indexToRemove!)
      }

      SubsystemsController.sharedInstance().securityController.setModePARTIALDevices(partialDevices)
    }
  }

  fileprivate func addDeviceToOn() {
    if var devices = SubsystemsController.sharedInstance().securityController.modeONDevices as? [Any],
      let delegate = delegate {

      devices.append((delegate.deviceAddress))

      SubsystemsController.sharedInstance().securityController.setModeONDevices(devices)
    }
  }

  fileprivate func addDeviceToPartial() {
    if var devices = SubsystemsController.sharedInstance().securityController.modePARTIALDevices as? [Any],
      let delegate = delegate {

      devices.append((delegate.deviceAddress))

      SubsystemsController.sharedInstance().securityController.setModePARTIALDevices(devices)
    }
  }
}

extension AlarmDeviceModePresenter: AlarmDeviceModePresenterProtocol {
  func navigationTitle() -> String {
    return deviceModel.name
  }

  func selectModeAtIndex(_ index: Int) {
    for deviceMode in deviceModes {
      deviceMode.isSelected = false
    }

    deviceModes[index].isSelected = true
    changeDeviceModelToMode(deviceModes[index].type)

    delegate?.shouldUpdateViews()
  }
}

class AlarmDeviceModeViewModel {
  var isSelected = false
  var type = AlarmDeviceModeType.notParticipating
  var title: String {
    switch type {
    case .onAndPartial:
      return DeviceModeTitle.onPartial
    case .on:
      return DeviceModeTitle.on
    case .partial:
      return DeviceModeTitle.partial
    case .notParticipating:
      return DeviceModeTitle.notParticipating
    }
  }

  init(type: AlarmDeviceModeType, isSelected: Bool) {
    self.type = type
    self.isSelected = isSelected
  }
}
