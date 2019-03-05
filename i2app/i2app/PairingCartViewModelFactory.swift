//
//  PairingCartViewModelFactory.swift
//  i2app
//
//  Arcus Team on 3/13/18.
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

/// A factory class providing convenience methods to initialze the pairing cart view
/// with common configurations like searching, troubleshooting tips, paired devices, etc.
protocol PairingCartViewModelFactory: ArcusPairingDeviceCapability,
                                      ArcusDeviceCapability {

  /// Creates a view model representing the pairing cart in its initial, "Searching for
  /// Devices" state.
  func searchingForDevicesView() -> PairingCartSectionViewModel
  
  /// Creates a view model representing the pairing cart in the search idle timeout state,
  /// listing help steps ("Troubleshooting Tips") provided by the platform.
  ///
  /// -withSteps: A list of HelpStepViewModels describing the help steps to displays
  func troubleshootingTipsView(withSteps: [HelpStepViewModel]) -> PairingCartSectionViewModel
  
  /// Creates a view model representing the pairing cart in found devices while searching state
  /// (home animation + devices list).
  /// -withDevices: A list of PairingDeviceViewModels describing each of the pairDev objects
  ///               presenting in the pairing cart.
  /// -stillSearching: An indication of whether the system is still se
  func devicesFoundSearching(pairDevs: [PairingDeviceModel], stillSearching: Bool) -> PairingCartSectionViewModel
}

/// A factory class providing convenience methods to initialze the pairing cart view
/// with common configurations like searching, troubleshooting tips, paired devices, etc.
extension PairingCartViewModelFactory {

  /// Creates a view model representing the pairing cart in its initial, "Searching for
  /// Devices" state.
  func searchingForDevicesView() -> PairingCartSectionViewModel {
    var cells: [PairingCartCellViewModel] = []
    cells.append(HomeAnimationSectionModel())
    cells.append(TitleSectionModel(
        title: "Searching for Devices",
        subtitle: "This may take a few minutes.\nPlease leave the app open.")
    )
    
    return PairingCartSectionViewModel(cells)
  }
  
  /// Creates a view model representing the pairing cart in the search idle timeout state,
  /// listing help steps ("Troubleshooting Tips") provided by the platform.
  ///
  /// -withSteps: A list of HelpStepViewModels describing the help steps to displays
  func troubleshootingTipsView(withSteps: [HelpStepViewModel]) -> PairingCartSectionViewModel {
    var cells: [PairingCartCellViewModel] = []

    cells.append(HomeAnimationSectionModel())
    cells.append(TitleSectionModel(
        title: "Searching for Devices",
        subtitle: "Hmmn... This is taking longer than usual. Please leave the app open and follow the steps below.")
    )
    cells.append(HorizontalRuleSectionModel())
    cells.append(SpacerSectionModel())
    cells.append(TroubleshootingTitleSectionModel())
    for (index, thisHelpStep) in withSteps.enumerated() {
      cells.append(TroubleshootingTipSectionModel(thisHelpStep, tipNumber: index + 1))
    }
    cells.append(SpacerSectionModel())
  
    return PairingCartSectionViewModel(cells)
  }
  
  /// Creates a view model representing the pairing cart in found devices while searching state
  /// (home animation + devices list).
  /// -withDevices: A list of PairingDeviceViewModels describing each of the pairDev objects
  ///               presenting in the pairing cart.
  /// -stillSearching: An indication of whether the system is still se
  func devicesFoundSearching(pairDevs: [PairingDeviceModel], stillSearching: Bool) -> PairingCartSectionViewModel {
    var cells: [PairingCartCellViewModel] = []
    
    if stillSearching {
      cells.append(HomeAnimationSectionModel())      
    } else if pairDevs.isEmpty {
      cells.append(NoDevicesSectionModel())      
    }

    if !stillSearching && pairDevs.isEmpty {
      cells.append(TitleSectionModel(
          title: "No Devices Found",
          subtitle: "Begin searching for devices by tapping Pair Device below."))
    } else {
      let deviceFound = pairDevs.count == 1 ?
        "1 Device Found!" :
        "\(pairDevs.count) Devices Found!"

      var subtitle = ""
      if pairDevs.filter({ pairDev in isDeviceCustomized(pairDev) }).count == pairDevs.count {
        subtitle = "All devices have been customized!"
      } else {
        subtitle = "Tap the device below to customize your device."
      }
      
      cells.append(TitleSectionModel(
          title: deviceFound,
          subtitle: subtitle))
      cells.append(HorizontalRuleSectionModel())
    }
    
    if !pairDevs.isEmpty {
      cells.append(contentsOf: getDevicesViewModels(pairDevs))
    }
    
    if stillSearching {
      return PairingCartSectionViewModel(cells)
    } else {
      if pairDevs.isEmpty {
        return PairingCartSectionViewModel(cells, topButton: "PAIR DEVICE")
      } else {
        return PairingCartSectionViewModel(cells, topButton: "PAIR ANOTHER DEVICE")
      }
    }
  }
  
  private func getDevicesViewModels(_ pairDevs: [PairingDeviceModel]) -> [PairingCartCellViewModel] {
    var models: [PairingCartCellViewModel] = []
    
    for thisPairDev in pairDevs {
    
      if isInErrorState(thisPairDev) {
        var deviceName = "Device Detected"
        
        if let devModel = getDeviceModel(thisPairDev),
           let name = getDeviceName(devModel) {
           
          deviceName = name
        }
      
        if thisPairDev.isPhilipsHue() {
          models.append(RemoveDeviceSectionModel(hue: thisPairDev))
        } else {
          models.append(RemoveDeviceSectionModel(
              pairDev: thisPairDev,
              deviceName: deviceName,
              disposition: getErrorStateDisposition(thisPairDev)))
        }
      } else if let devModel = getDeviceModel(thisPairDev) {

        let deviceAddr = devModel.address
        let deviceName = getDeviceName(devModel) ?? "Unnamed Device"
        let vendorName = getDeviceVendor(devModel) ?? ""
        let productId = getDeviceProductId(devModel) ?? ""
        let devTypeHint = getDeviceDevtypehint(devModel) ?? ""
        
        if isDeviceCustomized(thisPairDev) {
          models.append(CompletedDeviceSectionModel(
              deviceName: deviceName,
              vendorName: vendorName,
              productId: productId,
              devTypeHint: devTypeHint)
          )
        } else {
          models.append(CustomizeDeviceSectionModel(
              address: deviceAddr,
              deviceName: deviceName,
              vendorName: vendorName,
              productId: productId,
              devTypeHint: devTypeHint)
          )
        }
      } else {
        models.append(PendingDeviceSectionModel(
            deviceName: "Device Detected",
            disposition: getPairDevDisposition(thisPairDev))
        )
      }
    }
    
    return models
  }
  
  private func getErrorStateDisposition(_ pairDev: PairingDeviceModel) -> String {
    switch getPairingDevicePairingState(pairDev) ?? .paired {
      case .mispaired: return "Improperly Paired"
      case .misconfigured: return "Misconfigured"
      default: return ""
    }
  }
  
  private func isInErrorState(_ pairDev: PairingDeviceModel) -> Bool {
    return getPairingDevicePairingState(pairDev) == PairingDevicePairingState.mispaired ||
           getPairingDevicePairingState(pairDev) == PairingDevicePairingState.misconfigured
  }

  private func isDeviceCustomized(_ pairDev: PairingDeviceModel) -> Bool {
    return (getPairingDeviceCustomizations(pairDev) ?? []).contains(PairingCustomizationStepType.complete.rawValue)
  }

  private func getPairDevDisposition(_ pairDev: PairingDeviceModel) -> String {

    let pairDevState = getPairingDevicePairingState(pairDev)
    let pairDevPhase = getPairingDevicePairingPhase(pairDev)

    switch pairDevState ?? .misconfigured {
      case .paired: return pairDev.getName()

      default:
          switch pairDevPhase ?? .failed {
            case .join: return "Found New Device"
            case .connect: return "Connecting to Device"
            case .identify: return "Discovering Device Features"
            case .prepare: return "Prepairing Device for Use"
            case .configure: return "Writing Initial Settings"
            case .failed: return "Failed"
            case .paired: return "Paired"
          }
    }
  }

  private func getDeviceModel(_ pairDev: PairingDeviceModel) -> DeviceModel? {
    if let deviceAddress = getPairingDeviceDeviceAddress(pairDev),
       let devModel = RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel {

       return devModel
    } else {
      return nil
    }
  }
}
