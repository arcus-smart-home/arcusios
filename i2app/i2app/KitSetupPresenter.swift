//
//  KitSetupPresenter.swift
//  i2app
//
//  Created by Arcus Team on 7/17/18.
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

enum KitSetupDeviceType {
  case hub
  case motionSensor
  case contactSensor
  case keypad
  case smartPlug
  case unknown
}

enum KitSetupExitDisposition {
  case ready
  case activationIncomplete
  case customizationIncomplete
}

struct KitSetupImageName {
  static let warning = "alert_pink__80x80-ios"
  static let check = "successcheck_35x35-ios"
  static let hub = "v3hub_80x80-ios"
  static let contactSensor = "v3contactsensor_80x80-ios"
  static let keypad = "v3keypad_80x80-ios"
  static let motionSensor = "v3motionsensor_80x80-ios"
  static let smartPlug = "v3smartplug_80x80-ios"
  static let hubInactive = "v3hub_activate_80x80-ios"
  static let contactSensorInactive = "v3contactsensor_activate_80x80-ios"
  static let keypadInactive = "v3keypad_activate_80x80-ios"
  static let motionSensorInactive = "v3motionsensor_activate_80x80-ios"
  static let smartPlugInactive = "v3_smartplug_activate_80x80-ios"
}

struct KitSetupDevTypeHint {
  static let motion = "motion"
}

struct KitSetupViewModel {
  let needHelpURL = NSURL.SupportKitSetupHelp
  let tutorialVideoURL = NSURL.VideoKitSetup
  var kitDevices: Variable<[KitSetupDeviceViewModel]> = Variable([])
  var exitDisposition = KitSetupExitDisposition.ready
  var kitDeviceCount = 0
  var hasInactiveDevices = false
  var hasAllDevicesReady = false
}

struct KitSetupDeviceViewModel {
  var title = ""
  var subtitle = ""
  var imageName = ""
  var deviceAddress = ""
  var type = KitSetupDeviceType.unknown
  var state = KitSetupDeviceState.inactive
}

protocol KitSetupPresenter: ArcusPairingSubsystemCapability, ArcusProductCapability, KitSetupHelper,
ArcusHubCapability {
  
  var kitSetupViewModel: KitSetupViewModel { get set }
  
  func kitSetupDevicesDismissed()
  
  // MARK: Extended
  
  func kitSetupFetchDevices()
  func kitSetupDismissPairedDevices()
}

extension KitSetupPresenter {
  
  func kitSetupFetchDevices() {
    observeEvents()
    fetchKitDevices()
  }
  
  func kitSetupDismissPairedDevices() {
    guard let pairingSubsystem = pairingSubsystemModel() else {
      return
    }
    
    do {
      try requestPairingSubsystemListPairingDevices(pairingSubsystem)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] response in
          if let response = response as? PairingSubsystemListPairingDevicesResponse {
            self?.processForRemoval(listPairingResponse: response)
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - KitSetupPresenter error loading pairing devices for removal.")
    }
  }
  
  private func processForRemoval(listPairingResponse response: PairingSubsystemListPairingDevicesResponse) {
    guard let pairDevices = response.getDevices() as? [[String: AnyObject]] else {
      return
    }
    
    for pairDevice in pairDevices {
      let pairedDeviceModel = PairingDeviceModel(attributes: pairDevice)
      
      if let state = getPairingDevicePairingState(pairedDeviceModel),
        state == .paired {
        do {
          _ = try requestPairingDeviceDismiss(pairedDeviceModel)
        } catch {
          DDLogError("Error - KitSetupPresenter error dismissing paired device.")
        }
      }
    }
    
    kitSetupDevicesDismissed()
  }
  
  private func determineExitDisposition() -> KitSetupExitDisposition {
    let devices = kitSetupViewModel.kitDevices.value
    var disposition = KitSetupExitDisposition.ready
    
    for device in devices {
      if device.state == .activated {
        disposition = .customizationIncomplete
      } else if device.state == .inactive && disposition != .customizationIncomplete {
        disposition = .activationIncomplete
      }
    }
    
    return disposition
  }
  
  private func observeEvents() {
    guard let pairingSubsystem = pairingSubsystemModel(),
      let cache = RxCornea.shared.modelCache as? RxArcusModelCache else {
        return
    }
    
    pairingSubsystem.getEvents()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.fetchKitDevices()
      })
      .disposed(by: disposeBag)
    
    cache.getEvents()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.fetchKitDevices()
      })
      .disposed(by: disposeBag)
  }
  
  private func handleFailure() {
    DDLogError("Error - KitSetupPresenter error generating data for kit device grid.")
    
    guard let hub = createHubViewModel() else {
      return
    }
    
    var kitDevices = [KitSetupDeviceViewModel]()
    kitDevices.append(hub)
    
    kitSetupViewModel.kitDevices.value = kitDevices
    kitSetupViewModel.kitDeviceCount = 0
    kitSetupViewModel.exitDisposition = determineExitDisposition()
    kitSetupViewModel.hasInactiveDevices = false
  }
  
  private func fetchKitDevices() {
    guard let pairingSubsystem = pairingSubsystemModel() else {
      return
    }
    
    do {
      try requestPairingSubsystemGetKitInformation(pairingSubsystem)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] response in
          if let response = response as? PairingSubsystemGetKitInformationResponse {
            self?.process(kitInformationResponse: response)
          } else {
            self?.handleFailure()
          }
        })
        .disposed(by: disposeBag)
    } catch {
      handleFailure()
      DDLogError("Error - KitSetupPresenter error loading kit devices.")
    }
  }
  
  private func process(kitInformationResponse response: PairingSubsystemGetKitInformationResponse) {
    guard let kitInfo = response.getKitInfo() as? [[String: AnyObject]] else {
      return
    }
    
    fetchPairingDevices(forKitInfo: kitInfo)
  }
  
  private func fetchPairingDevices(forKitInfo kitInfo: [[String: AnyObject]]) {
    guard let pairingSubsystem = pairingSubsystemModel() else {
      return
    }
    
    do {
      try requestPairingSubsystemListPairingDevices(pairingSubsystem)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] response in
          if let response = response as? PairingSubsystemListPairingDevicesResponse {
            self?.process(listPairingResponse: response, kitInfo: kitInfo)
          } else {
            self?.handleFailure()
          }
        })
        .disposed(by: disposeBag)
    } catch {
      handleFailure()
      DDLogError("Error - KitSetupPresenter error loading pairing devices.")
    }
  }
  
  private func process(listPairingResponse response:PairingSubsystemListPairingDevicesResponse,
                       kitInfo: [[String: AnyObject]]) {
    guard let pairDevices = response.getDevices() as? [[String: AnyObject]] else {
      return
    }
    
    // Transform dictionaries to models.
    let pairDeviceModels = pairDevices.map { (device) -> PairingDeviceModel in
      PairingDeviceModel(attributes: device)
    }
     
    var kitDevices = [KitSetupDeviceViewModel]()
    
    if let hub = createHubViewModel() { kitDevices.append(hub) }
    var hasInactiveDevices = false
    var hasAllDevicesReady = true
    
    for kitInfoData in kitInfo {
      let productId = kitInfoData["productId"] as? String ?? ""
      let protocolAddress = kitInfoData["protocolAddress"] as? String ?? ""
      let state = deviceState(pairingDevices: pairDeviceModels, protocolAddress: protocolAddress)
      let type = deviceType(forProductId: productId)
      
      var newKitDevice = KitSetupDeviceViewModel()
      newKitDevice.state = state
      newKitDevice.type = type
      newKitDevice.subtitle = deviceSubtitle(deviceType: type, deviceState: state)
      newKitDevice.imageName = imageName(deviceType: type, deviceState: state)
      newKitDevice.title = deviceTitle(productId: productId,
                                       protocolAddress: protocolAddress,
                                       state: state)
      
      if let deviceModel = deviceModel(forProtocolAddress: protocolAddress) {
        newKitDevice.deviceAddress = deviceModel.address
      }
      
      // All devices must be both active and customized in order for this screen
      // to consider a device to be completely ready.
      if state != .activatedAndCustomized {
        hasAllDevicesReady = false
      }
      
      // If at least one of the devices is inactive the view should consider the hub to
      // be "searching".
      if state == .inactive {
        hasInactiveDevices = true
      }
      
      // Ensure that the view models added have all the required data.
      if !newKitDevice.imageName.isEmpty && !newKitDevice.title.isEmpty {
        kitDevices.append(newKitDevice)
      }
    }
    
    kitSetupViewModel.kitDevices.value = kitDevices
    kitSetupViewModel.kitDeviceCount = kitInfo.count + 1
    kitSetupViewModel.exitDisposition = determineExitDisposition()
    kitSetupViewModel.hasInactiveDevices = hasInactiveDevices
    kitSetupViewModel.hasAllDevicesReady = hasAllDevicesReady
  }
  
  private func deviceType(forProductId productId: String) -> KitSetupDeviceType {
    guard let product = productModel(forProductId: productId), let screen = product.screenName() else {
      return .unknown
    }
    
    switch screen.lowercased() {
    case "contact":
      return .contactSensor
    case "motion":
      return .motionSensor
    case "switch":
      return .smartPlug
    case "keypad":
      return .keypad
    case "hub":
      return .hub
    default:
      return .unknown
    }
  }
  
  private func deviceTitle(productId: String,
                           protocolAddress: String,
                           state: KitSetupDeviceState) -> String {
    var title = ""
    
    if state == .activated || state == .activatedAndCustomized {
      if let device = deviceModel(forProtocolAddress: protocolAddress) {
        title = device.name
      }
    } else {
      if let product = productModel(forProductId: productId),
        let name = getProductShortName(product) {
        title = name
      }
    }
    
    return title
  }
  
  private func deviceSubtitle(deviceType: KitSetupDeviceType, deviceState: KitSetupDeviceState) -> String {
    var subtitle = ""
    
    switch deviceState {
    case .improperlyPaired:
      subtitle = "Improperly Paired"
    case .missing:
      subtitle = "Error"
    case .inactive:
      if deviceType == .smartPlug {
        subtitle = "Plug it in"
      } else {
        subtitle = "Pull the tab"
      }
    case .activated:
      subtitle = "Customize"
    default:
      subtitle = ""
    }
    
    return subtitle
  }
  
  private func imageName(deviceType: KitSetupDeviceType, deviceState: KitSetupDeviceState) -> String {
    var imageName = ""
    
    if deviceState == .improperlyPaired || deviceState == .missing {
      imageName = KitSetupImageName.warning
    } else if deviceState == .inactive {
      switch deviceType {
      case .motionSensor:
        imageName = KitSetupImageName.motionSensorInactive
      case .contactSensor:
        imageName = KitSetupImageName.contactSensorInactive
      case .smartPlug:
        imageName = KitSetupImageName.smartPlugInactive
      case .keypad:
        imageName = KitSetupImageName.keypadInactive
      default:
        break
      }
    } else {
      switch deviceType {
      case .motionSensor:
        imageName = KitSetupImageName.motionSensor
      case .contactSensor:
        imageName = KitSetupImageName.contactSensor
      case .smartPlug:
        imageName = KitSetupImageName.smartPlug
      case .keypad:
        imageName = KitSetupImageName.keypad
      default:
        break
      }
    }
    
    return imageName
  }
  
  private func createHubViewModel() -> KitSetupDeviceViewModel? {
    guard let model = hubModel() else {
      return nil
    }
    
    var hub = KitSetupDeviceViewModel()
    hub.imageName = KitSetupImageName.hub
    hub.title = getHubName(model) ?? ""
    hub.subtitle = ""
    hub.state = .activatedAndCustomized
    hub.type = .hub
    
    return hub
  }
  
  private func hubModel() -> HubModel? {
    let namespace = Constants.hubNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [HubModel] else {
      return nil
    }
    
    return models.first
  }
  
  private func productModel(forProductId productId: String) -> ProductModel? {
    let namespace = Constants.productNamespace
    
    guard let productModels = RxCornea.shared.modelCache?.fetchModels(namespace) as? [ProductModel] else {
      return nil
    }
    
    for productModel in productModels where productModel.productId() == productId {
      return productModel
    }
    
    return nil
  }
  
  private func pairingSubsystemModel() -> SubsystemModel? {
    let namespace = Constants.pairingSubsystemNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [SubsystemModel] else {
      return nil
    }
    
    return models.first
  }
  
}

