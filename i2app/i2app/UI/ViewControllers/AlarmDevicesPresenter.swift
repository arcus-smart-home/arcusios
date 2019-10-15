//
//  AlarmDevicesPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/20/17.
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

private enum SectionTitle {
  static let participatingGeneric = NSLocalizedString("Participating Devices", comment: "")
  static let participatingSecurity = NSLocalizedString("On & Partial Devices", comment: "")
  static let notParticipating = NSLocalizedString("Not Participating Devices", comment: "")
  static let bypassed = NSLocalizedString("Bypassed Devices", comment: "")
}

enum AlarmDevicesSectionType {
  case bypassed
  case participating
  case notParticipating
}

protocol AlarmDevicesDelegate : class {
  var alarmType: AlarmType { get set }

  func shouldUpdateViews()
}

protocol AlarmDevicesPresenterProtocol {
  var delegate: AlarmDevicesDelegate? { get set }
  var alarmDevicesViewModel: AlarmDevicesViewModel { get set }
  var sections: [AlarmDevicesSectionType] { get set }

  func navigationTitle() -> String
  func fetchAlarmDevices()
  func deviceListForSection(_ sectionNumber: Int) -> [AlarmDeviceViewModel]
  func titleForSection(_ sectionNumber: Int) -> String
  func rowsForSection(_ sectionNumber: Int) -> Int
  func deviceAddressForIndexPath(_ indexPath: IndexPath) -> String
}

class AlarmDevicesPresenter: AlarmSubsystemController, AlarmModelController, DeviceImageLoader {

  weak var delegate: AlarmDevicesDelegate?
  var subsystemModel: SubsystemModel = SubsystemModel()
  var alarmDevicesViewModel = AlarmDevicesViewModel()
  var sections = [AlarmDevicesSectionType]()

  init(delegate: AlarmDevicesDelegate) {
    self.delegate = delegate

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AlarmDevicesPresenter.fetchData),
      name: Notification.Name.subsystemCacheInitialized,
      object: nil)

    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.subsystemModel = alarmSubsystem
    }
  }

  // MARK: Callbacks
  @objc func fetchData() {
    fetchAlarmDevices()
  }
}

// MARK: AlarmDevicesPresenterProtocol
extension AlarmDevicesPresenter: AlarmDevicesPresenterProtocol {
  func fetchAlarmDevices() {
    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.subsystemModel = alarmSubsystem
    }

    DispatchQueue.global(qos: .background).async {
      for alarmModel in self.alarmModels(self.subsystemModel) {
        guard let name = alarmModel.getAttribute(kMultiInstanceTypeKey) as? String else {
          continue
        }

        // Current alarm model
        if name == self.delegate?.alarmType.rawValue {
          self.createAlarmDevicesViewModel(alarmModel)
          return
        }
      }
    }
  }

  func deviceAddressForIndexPath(_ indexPath: IndexPath) -> String {
    if indexPath.section >= sections.count {
      return ""
    }

    switch sections[indexPath.section] {
    case .bypassed:
      return alarmDevicesViewModel.devicesBypassed[indexPath.row].address
    case .participating:
      return alarmDevicesViewModel.devicesParticipating[indexPath.row].address
    case .notParticipating:
      return alarmDevicesViewModel.devicesNotParticipating[indexPath.row].address
    }
  }

  func navigationTitle() -> String {
    return "\(delegate!.alarmType.rawValue) DEVICES"
  }

  func deviceListForSection(_ sectionNumber: Int) -> [AlarmDeviceViewModel] {
    if sectionNumber >= sections.count {
      return [AlarmDeviceViewModel]()
    }

    switch sections[sectionNumber] {
    case .bypassed:
      return alarmDevicesViewModel.devicesBypassed
    case .participating:
      return alarmDevicesViewModel.devicesParticipating
    case .notParticipating:
      return alarmDevicesViewModel.devicesNotParticipating
    }
  }

  func titleForSection(_ sectionNumber: Int) -> String {
    if sectionNumber >= sections.count {
      return ""
    }

    switch sections[sectionNumber] {
    case .bypassed:
      return SectionTitle.bypassed
    case .participating:
      if delegate?.alarmType == .Security {
        return SectionTitle.participatingSecurity
      } else {
        return SectionTitle.participatingGeneric
      }
    case .notParticipating:
      return SectionTitle.notParticipating
    }
  }

  func rowsForSection(_ sectionNumber: Int) -> Int {
    if sectionNumber >= sections.count {
      return 0
    }

    switch sections[sectionNumber] {
    case .bypassed:
      return alarmDevicesViewModel.devicesBypassed.count
    case .participating:
      return alarmDevicesViewModel.devicesParticipating.count
    case .notParticipating:
      return alarmDevicesViewModel.devicesNotParticipating.count
    }
  }
}

// MARK: View Model Manipulation
extension AlarmDevicesPresenter {
  fileprivate func createAlarmDevicesViewModel(_ alarmModel: AlarmModel) {
    if delegate?.alarmType == .Security {
      var participatingAddresses = [String]()
      var notParticipatingAddresses = [String]()
      var bypassAddresses = [String]()

      let allAddresses = devices(alarmModel)

      // Sort devices into participating and not participating
      for address in allAddresses {
        guard let model = RxCornea.shared.modelCache?.fetchModel(address) as?
          DeviceModel else {
            continue
        }

        if model.securityModeStatus() == "Not Participating" {
          notParticipatingAddresses.append(address)
        } else {
          if isAddressBypassed(address, alarmModel: alarmModel) {
            bypassAddresses.append(address)
          } else {
            participatingAddresses.append(address)
          }
        }
      }

      alarmDevicesViewModel.devicesParticipating =
        deviceModelsToViewModels(participatingAddresses)
      alarmDevicesViewModel.devicesNotParticipating =
        deviceModelsToViewModels(notParticipatingAddresses)
      alarmDevicesViewModel.devicesBypassed =
        deviceModelsToViewModels(bypassAddresses, isBypass: true)
    } else {
      alarmDevicesViewModel.devicesParticipating = deviceModelsToViewModels(devices(alarmModel))
    }

    updateSections()
    delegate?.shouldUpdateViews()
  }

  fileprivate func deviceModelsToViewModels(_ deviceAddresses: [String],
                                            isBypass: Bool = false) -> [AlarmDeviceViewModel] {
    var viewModels = [AlarmDeviceViewModel]()

    for device in deviceAddresses {
      guard let model = RxCornea.shared.modelCache?.fetchModel(device) as?
        DeviceModel else {
          continue
      }

      let viewModel = AlarmDeviceViewModel()

      // Common Values
      viewModel.title = model.name
      viewModel.image = UIImage()
      viewModel.address = device
      viewModel.isOffline = model.isDeviceOffline()
      viewModel.isBypassed = isBypass

      // Fetch Device Image
      self.imageForDeviceModel(model, large: false, black: false, completionHandler: { (image, _) in
        viewModel.image = image!
        self.delegate?.shouldUpdateViews()
      })

      // Fetch subtitle if the alarm type is not security.
      if delegate?.alarmType == .Security {
        if viewModel.isOffline {
          viewModel.subtitle = ""
        } else {
          viewModel.subtitle = model.securityDeviceStatus()
        }

        if model.securityModeStatus() == "Not Participating" {
          viewModel.mode = ""
        } else {
          viewModel.mode = model.securityModeStatus()
        }
      } else if !viewModel.isOffline {
        DispatchQueue.global(qos: .background).async {
          _ = model.productShortName().swiftThenInBackground({
            modelAnyObject in

            guard let shortName = modelAnyObject as? String else {
              return nil
            }

            viewModel.subtitle = shortName
            self.delegate?.shouldUpdateViews()

            return nil
          })
        }
      }

      viewModels.append(viewModel)
    }

    return viewModels
  }

  fileprivate func isAddressBypassed(_ address: String, alarmModel: AlarmModel) -> Bool {
    let bypassedAddresses = triggeredDevices(alarmModel)

    for bypassedAddress in bypassedAddresses where bypassedAddress == address {
      return true
    }

    return false
  }

  fileprivate func updateSections() {
    if delegate?.alarmType == .Security {
      sections = [AlarmDevicesSectionType]()
      if alarmDevicesViewModel.devicesBypassed.count > 0 {
        sections.append(.bypassed)
      }
      if alarmDevicesViewModel.devicesParticipating.count > 0 {
        sections.append(.participating)
      }
      if alarmDevicesViewModel.devicesNotParticipating.count > 0 {
        sections.append(.notParticipating)
      }
    } else {
      sections = [.participating]
    }
  }
}

// MARK: Helper Functions
extension AlarmDevicesPresenter {
  fileprivate func alarmModelNameToAlarmType(_ alarmName: String) -> AlarmType {
    if alarmName == AlarmType.Security.rawValue {
      return AlarmType.Security
    } else if alarmName == AlarmType.Panic.rawValue {
      return AlarmType.Panic
    } else if alarmName == AlarmType.CO.rawValue {
      return AlarmType.CO
    } else if alarmName == AlarmType.Water.rawValue {
      return AlarmType.Water
    } else {
      return AlarmType.Smoke
    }
  }
}

struct AlarmDevicesViewModel {
  var devicesParticipating = [AlarmDeviceViewModel]()
  var devicesBypassed = [AlarmDeviceViewModel]()
  var devicesNotParticipating = [AlarmDeviceViewModel]()
}

class AlarmDeviceViewModel {
  var image = UIImage()
  var title = ""
  var subtitle = ""
  var mode = ""
  var address = ""
  var isOffline = false
  var isBypassed = false
}
