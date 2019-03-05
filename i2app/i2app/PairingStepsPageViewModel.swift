//
//  PairingStepsPageViewModel.swift
//  i2app
//
//  Arcus Team on 2/16/18.
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
import CoreBluetooth
import Cornea

extension Constants {
  struct V1DeviceType {
    static let swannWifiPlug: String = "SwannWifiPlug"
    static let swannBatteryCamera: String = "SwannWifiBatteryCamera"
    static let greatStarIndoorPlug: String = "GreatStarIndoorPlug"
    static let greatStarOutdoorPlug: String = "GreatStarOutdoorPlug"
  }

  struct WSSPairingIdentifiers {
    static let configureNetwork: String = "WSSConfigureNetworkViewController"
    static let externalSettings: String = "WSSExternalSettingsInfoViewController"
  }

  struct BLEPairingIdentifiers {
    static let availability: String = "BLEPairingAvailabilityViewController"
    static let pairngInfo: String = "BLEPairingInfoStepViewController"
    static let discoverDevices: String = "BLEPairingDeviceDiscoveryViewController"
    static let availableNetworks: String = "BLEPairingAvailableNetworksViewController"
    static let configure: String = "BLEPairingConfigureNetworkViewController"

    static var wifiPlugIdentifiers: [String] = [availability, discoverDevices, availableNetworks, configure]
    static var wifiSecurityCameraIdentifiers: [String] = [availability,
                                                          pairngInfo,
                                                          discoverDevices,
                                                          availableNetworks,
                                                          configure]
  }
}

protocol ArcusPairingStepViewModel {

}

struct CustomPairingStepViewModel: ArcusPairingStepViewModel {
  var identifier: String
  var order: Int
  var config: Any?

  init(identifier: String, order: Int, config: Any? = nil) {
    self.identifier = identifier
    self.order = order
    self.config = config
  }
}

/// Represents the data needed to render any individual platform-provided pairing step.
struct PairingStepsStepViewModel: ArcusPairingStepViewModel {

  var productAddress: String
  var id: String?
  var order: Int?
  var title: String?
  var info: String?
  var instructions: [String]?
  var linkText: String?
  var linkUrl: String?
  var externalAppUrl: String?
  var secondaryActionText: String?
  var secondaryActionURL: URL?
  
  var form: [PairingStepInput]?

  init(productAddress: String) {
    self.productAddress = productAddress
  }
  
  init(_ data: [String:AnyObject], form: [PairingStepInput]?, productAddress: String) {
    self.productAddress = productAddress
    self.form = form

    self.id = data["id"] as? String
    self.order = data["order"] as? Int
    self.title = data["title"] as? String
    self.info = data["info"] as? String
    self.instructions = data["instructions"] as? [String]
    self.linkText = data["linkText"] as? String
    self.linkUrl = data["linkUrl"] as? String
    
    if let externalAppData = data["externalApps"] as? [[String: AnyObject]] {
      for appData in externalAppData {
        if let platform = appData["platform"] as? String,
          platform.uppercased() == "IOS",
          let appURL = appData["appUrl"] as? String {
          externalAppUrl = appURL
        }
      }
    }
  }
}

/// Represents the data needed to render all platform-provided pairing steps.
struct PairingStepsViewModel {

  var productAddress: String
  var pairingMode: String?
  var steps: [ArcusPairingStepViewModel]
  var videoUrl: String?
  var form: [PairingStepInput]
  var c2cUrl: URL?
  var c2cStyle: CloudToCloudStyle?
  var isWiFiPairing: Bool = false
  var isBLEPairing: Bool = false
  var isVoiceAssistant: Bool = false
  var bleSearchFilter: String = ""
  var ipcdDeviceType: String = ""

  init(_ pairingResponse: PairingSubsystemStartPairingResponse, productAddress: String) {
    self.productAddress = productAddress
    self.pairingMode = pairingResponse.getMode()?.rawValue
    self.videoUrl = pairingResponse.getVideo()
    self.c2cUrl = URL(string: pairingResponse.getOauthUrl() ?? "")
    self.c2cStyle = CloudToCloudStyle(rawValue: pairingResponse.getOauthStyle() ?? "")

    // Parse form data when present
    self.form = []
    let formList = pairingResponse.getForm() ?? []
    for thisForm in formList {
      if let thisFormData = thisForm as? [String:AnyObject] {
        let formStep = PairingStepInput(thisFormData)

        // Check form for value indicating WSS pairing.
        self.isWiFiPairing = formStep.value == Constants.V1DeviceType.swannWifiPlug

        // Check form for value indicating WiFi Camera Pairing (requires BLE).
        if formStep.name == "IPCD:v1devicetype", let value = formStep.value {
          self.ipcdDeviceType = value
        }

        // If BLE Pairing, set device search filter.
        if formStep.value == Constants.V1DeviceType.swannBatteryCamera {
          self.isBLEPairing = true
          self.bleSearchFilter = Constants.bleCameraFilter
        } else if formStep.value == Constants.V1DeviceType.greatStarIndoorPlug
          || formStep.value == Constants.V1DeviceType.greatStarOutdoorPlug {
          self.isBLEPairing = true
          self.bleSearchFilter = Constants.bleWSSFilter
        }

        self.form.append(PairingStepInput(thisFormData))
      }
    }

    // Parse platform-provided steps
    self.steps = []
    let stepList = pairingResponse.getSteps() ?? []
    for (index, thisStep) in stepList.enumerated() {
      let lastStep = index == stepList.count - 1
      if let thisStepData = thisStep as? [String:AnyObject] {
        self.steps.append(PairingStepsStepViewModel(thisStepData,
                                                    form: lastStep ? form : nil,
                                                    productAddress: self.productAddress))
      }
    }

    if isWiFiPairing {
      self.steps.append(contentsOf: PairingStepsViewModel.wifiSmartSwitchCustomSteps())
    }

    if isBLEPairing {
      self.steps.append(contentsOf: PairingStepsViewModel.bleDeviceCustomSteps(ipcdDeviceType))
    }

    DDLogInfo("\(self.steps)")
  }
  
  func isCloudToCloudConnected() -> Bool {
    return c2cStyle != nil && c2cUrl != nil
  }

  private static func wifiSmartSwitchCustomSteps() -> [ArcusPairingStepViewModel] {
    let config: WSSNetworkConfig = WSSNetworkConfig()
    return [CustomPairingStepViewModel(identifier: Constants.WSSPairingIdentifiers.configureNetwork,
                                       order: 1,
                                       config: config),
            CustomPairingStepViewModel(identifier: Constants.WSSPairingIdentifiers.externalSettings,
                                       order: 2,
                                       config: config)]
  }

  private static func bleDeviceCustomSteps(_ ipcdDeviceType: String) -> [ArcusPairingStepViewModel] {
    var identifiers: [String] = []
    var filter: String?

    switch ipcdDeviceType {
    case Constants.V1DeviceType.swannBatteryCamera:
      identifiers = Constants.BLEPairingIdentifiers.wifiSecurityCameraIdentifiers
      filter = Constants.bleCameraFilter
    case Constants.V1DeviceType.greatStarIndoorPlug, Constants.V1DeviceType.greatStarOutdoorPlug:
      identifiers = Constants.BLEPairingIdentifiers.wifiPlugIdentifiers
      filter = Constants.bleWSSFilter
    default:
      break
    }

    let config: BLEPairingClient = BLEPairingClient(CBCentralManager(),
                                                    searchFilter: filter,
                                                    ipcdDeviceType: ipcdDeviceType)

    var result: [ArcusPairingStepViewModel] = []

    for (index, identifier) in identifiers.enumerated() {
      let index = index + 1
      result.append(CustomPairingStepViewModel(identifier: identifier, order: index, config: config))
    }

    return result
  }
}

/// Represents a pairing step input field (used only on cloud-connected devices
/// which require the user to enter data (like a serial number) to pair the device.
struct PairingStepInput {

  var type: String?
  var name: String?
  var label: String?
  var value: String?
  var required: Bool?
  var minlen: Int?
  var maxlen: Int?

  init(_ data: [String:AnyObject]) {
    self.type = data["type"] as? String
    self.name = data["name"] as? String
    self.label = data["label"] as? String
    self.value = data["value"] as? String
    self.required = data["required"] as? Bool
    self.minlen = data["minlen"] as? Int
    self.maxlen = data["maxlen"] as? Int
  }
  
  func isHidden() -> Bool {
    return (self.type ?? "HIDDEN") == "HIDDEN"
  }
}

enum CloudToCloudStyle: String {
  case honeywell = "HONEYWELL"
  case nest = "NEST"
  case lutron = "LUTRON"
}

protocol PairingStepsStepViewControllerFactory {
  func pairingStepsStepViewController(_ step: ArcusPairingStepViewModel,
                                      presenter: PairingStepsPresenter) -> UIViewController?
}

extension PairingStepsStepViewControllerFactory {
  func pairingStepsStepViewController(_ step: ArcusPairingStepViewModel,
                                      presenter: PairingStepsPresenter) -> UIViewController? {
    if step is PairingStepsStepViewModel {
      return PairingInstructionViewController.fromPairingStep(step: step, presenter: presenter)
    } else if let step = step as? CustomPairingStepViewModel,
      let presenter = presenter as? (PairingStepsPresenter & BLEPairingPresenterProtocol) {
      switch step.identifier {
      case Constants.WSSPairingIdentifiers.configureNetwork:
        return WSSConfigureNetworkViewController.fromPairingStep(step: step, presenter: presenter)
      case Constants.WSSPairingIdentifiers.externalSettings:
        return WSSExternalSettingsInfoViewController.fromPairingStep(step: step, presenter: presenter)
      case Constants.BLEPairingIdentifiers.availability:
        return BLEPairingAvailabilityViewController.fromPairingStep(step: step, presenter: presenter)
      case Constants.BLEPairingIdentifiers.pairngInfo:
        return BLEPairingInfoStepViewController.fromPairingStep(step: step,
                                                                presenter: presenter as BLEPairingPresenterProtocol)
      case Constants.BLEPairingIdentifiers.discoverDevices:
        return BLEPairingDeviceDiscoveryViewController.fromPairingStep(step: step,
                                                                             presenter: presenter as BLEPairingPresenterProtocol)
      case Constants.BLEPairingIdentifiers.availableNetworks:
        return BLEPairingAvailableNetworksViewController.fromPairingStep(step: step,
                                                                         presenter: presenter as BLEPairingPresenterProtocol)
      case Constants.BLEPairingIdentifiers.configure:
        return BLEPairingConfigureNetworkViewController.fromPairingStep(step: step,
                                                                        presenter: presenter as BLEPairingPresenterProtocol)
      default:
        break
      }
      return nil
    } else {
      return UIViewController()
    }
  }
}
