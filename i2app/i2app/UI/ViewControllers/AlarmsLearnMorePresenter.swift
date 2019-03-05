//
//  AlarmsLearnMorePresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/8/17.
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

protocol AlarmsLearnMorePresenterDelegate: class {
  var alarmType: AlarmType { get set }
}

protocol AlarmsLearnMorePresenterProtocol {
  weak var delegate: AlarmsLearnMorePresenterDelegate? { get set }

  var viewModel: AlarmsLearnMoreViewModel { get set }
  func navigationTitle() -> String
}

class AlarmsLearnMorePresenter {
  weak var delegate: AlarmsLearnMorePresenterDelegate?
  var viewModel: AlarmsLearnMoreViewModel

  init(delegate: AlarmsLearnMorePresenterDelegate) {
    self.delegate = delegate

    viewModel = AlarmsLearnMoreViewModel(alarmType: delegate.alarmType)
  }
}

extension AlarmsLearnMorePresenter: AlarmsLearnMorePresenterProtocol {
  func navigationTitle() -> String {
    if delegate?.alarmType == .Water {
      return "Water Leak"
    }

    return (delegate?.alarmType.rawValue)!
  }
}

class AlarmsLearnMoreViewModel {
  var alarmType: AlarmType

  var imageName: String {
    switch alarmType {
    case .Smoke:
      return AlarmsLearmMoreConstants.iconSmoke
    case .CO:
      return AlarmsLearmMoreConstants.iconCO
    case .Water:
      return AlarmsLearmMoreConstants.iconWater
    default:
      return AlarmsLearmMoreConstants.iconSecurity
    }
  }

  var title: String {
    switch alarmType {
    case .Smoke:
      return AlarmsLearmMoreConstants.titleSmoke
    case .CO:
      return AlarmsLearmMoreConstants.titleCO
    case .Water:
      return AlarmsLearmMoreConstants.titleWater
    default:
      return AlarmsLearmMoreConstants.titleSecurity
    }
  }

  var subtitle: String {
    switch alarmType {
    case .Smoke:
      return AlarmsLearmMoreConstants.subtitleSmoke
    case .CO:
      return AlarmsLearmMoreConstants.subtitleCO
    case .Water:
      return AlarmsLearmMoreConstants.subtitleWater
    default:
      return AlarmsLearmMoreConstants.subtitleSecurity
    }
  }

  var deviceList = ""

  var deviceInfo: String {
    switch alarmType {
    case .Smoke:
      return AlarmsLearmMoreConstants.deviceInfoSmoke
    case .CO:
      return AlarmsLearmMoreConstants.deviceInfoCO
    case .Water:
      return AlarmsLearmMoreConstants.deviceInfoWater
    default:
      return AlarmsLearmMoreConstants.deviceInfoSecurity
    }
  }

  var buttonTitle: String {
    switch alarmType {
    case .Smoke:
      return AlarmsLearmMoreConstants.buttonTitleSmoke
    case .CO:
      return AlarmsLearmMoreConstants.buttonTitleCO
    case .Water:
      return AlarmsLearmMoreConstants.buttonTitleWater
    default:
      return AlarmsLearmMoreConstants.buttonTitleSecurity
    }
  }

  var buttonURL: String {
    switch alarmType {
    case .Smoke:
      return AlarmsLearmMoreConstants.buttonURLSmoke
    case .CO:
      return AlarmsLearmMoreConstants.buttonURLCO
    case .Water:
      return AlarmsLearmMoreConstants.buttonURLWater
    default:
      return AlarmsLearmMoreConstants.buttonURLSecurity
    }
  }

  required init(alarmType: AlarmType) {
    self.alarmType = alarmType

    if alarmType == .Security {
      deviceList = AlarmsLearmMoreConstants.deviceListSecurity
    }
  }
}

enum AlarmsLearmMoreConstants {
  static let iconSmoke = "Smoke_white_filled"
  static let iconCO = "CO_White_filled"
  static let iconWater = "Leak_white_filled"
  static let iconSecurity = "Security_white_filled"

  static let titleSmoke = NSLocalizedString(
    "The Smoke Alarm service helps protect your family and home from fire " +
    "emergencies.",
    comment: "")
  static let titleCO = NSLocalizedString(
    "The CO Alarm service helps protect your family from danger when CO is " +
    "detected in your home.",
    comment: "")
  static let titleWater = NSLocalizedString(
    "The Water Leak Alarm service helps prevent water damage or flooding from occurring.",
    comment: "")
  static let titleSecurity = NSLocalizedString(
    "The Security Alarm service helps you protect what matters most.",
    comment: "")

  static let subtitleSmoke = NSLocalizedString(
    "To enable this feature, at least one Smoke Detector must be paired.",
    comment: "")
  static let subtitleCO = NSLocalizedString(
    "To enable this feature, at least one Carbon Monoxide detector must be paired.",
    comment: "")
  static let subtitleWater = NSLocalizedString(
    "To enable this feature, at least one water leak sensor must be paired.",
    comment: "")
  static let subtitleSecurity = NSLocalizedString(
    "To enable this feature, at least one of the following devices must be paired:",
    comment: "")

  static let deviceInfoSmoke = NSLocalizedString(
    "More than 1 smoke detector is strongly recommended to protect your home.",
    comment: "")
  static let deviceInfoCO = NSLocalizedString(
    "More than 1 carbon monoxide detector is strongly recommended to properly " +
    "secure your home.",
    comment: "")
  static let deviceInfoWater = NSLocalizedString(
    "More than 1 water leak sensor is strongly recommended to properly secure your " +
    "home. Add a water shut-off valve to automatically turn off the main water line " +
    "coming into the home to help prevent a large water leak.",
    comment: "")
  static let deviceInfoSecurity = NSLocalizedString(
    "More than 1 security device is strongly recommended to properly secure your home " +
    "and reduce false alarms.",
    comment: "")

  static let buttonTitleSmoke = NSLocalizedString(
    "SHOP SMOKE DEVICES",
    comment: "")
  static let buttonTitleCO = NSLocalizedString(
    "SHOP CO DEVICES",
    comment: "")
  static let buttonTitleWater = NSLocalizedString(
    "SHOP WATER LEAK DEVICES",
    comment: "")
  static let buttonTitleSecurity = NSLocalizedString(
    "SHOP SECURITY DEVICES",
    comment: "")

  static let buttonURLSmoke = NSURL.ProductsSmoke.absoluteString
  static let buttonURLCO = NSURL.ProductsSmoke.absoluteString
  static let buttonURLWater = NSURL.ProductsWater.absoluteString
  static let buttonURLSecurity = NSURL.ProductsSecurity.absoluteString

  static let deviceListSecurity = "Contact Sensor\nMotion Sensor\nGlass Break Sensor" +
  "\nCameras (via Internal Motion Sensor)\nDoor Hinge Sensor\nTilt Sensor"
}
