//
//  BLEPairingModels.swift
//  i2app
//
//  Created by Arcus Team on 8/24/18.
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

public enum BLEPairingConfigStatus: String {
  case intial = ""
  case connecting = "CONNECTING"
  case connected = "CONNECTED"
  case disconnected =  "DISCONNECTED"
  case badSSID = "BAD_SSID"
  case badKey = "BAD_PASS"
  case badPassword = "BAD_PASSWORD"
  case noInternet = "NO_INTERNET"
  case noServer = "NO_SERVER"
  case failed = "FAILED"

  public func description() -> String {
    switch self {
    case .intial:
      return "N/A"
    case .connecting:
      return "Connecting"
    case .connected:
      return "Connected"
    case .disconnected:
      return "Disconencted"
    case .badSSID:
      return "Bad SSID"
    case .badKey:
      return "Bad Key"
    case .badPassword:
      return "Bad Password"
    case .noInternet:
      return "No Internet"
    case .noServer:
      return "No Server"
    case .failed:
      return "Failed"
    }
  }

  public func error(v1DeviceType: String) -> Error? {
    switch self {
    case .disconnected:
      guard v1DeviceType != Constants.V1DeviceType.greatStarIndoorPlug
        && v1DeviceType != Constants.V1DeviceType.greatStarOutdoorPlug else {
        return nil
      }
      return BLEPairingError(configStatus: self, message: "")
    case .badSSID, .badKey, .noInternet, .noServer, .failed:
      return BLEPairingError(configStatus: self, message: "")
    default:
      return nil
    }
  }
}

public struct BLEPairingError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorCode
  }
  public var message: String!

  var errorCode: String!

  public init() {}

  public init(errorType: ErrorType = .unknown, message: String = "") {
    self.errorType = errorType
    self.errorCode = errorType.rawValue
    self.message = message
  }

  public init?(code: String, message: String) {
    var type: ErrorType = .unknown
    if let codeType = ErrorType(rawValue: code) {
      type = codeType
    }

    self.errorType = type
    self.errorCode = code
    self.message = message
  }

  public init?(configStatus: BLEPairingConfigStatus, message: String) {
    self.init(code: "error.ble." + configStatus.rawValue, message: message)
  }

  public enum ErrorType: String, RawRepresentable {
    case unknown = "error.ble.UNKNOWN"
    case disconnected = "error.ble.DISCONNECTED"
    case badSSID = "error.ble.BAD_SSID"
    case badKey = "error.ble.BAD_KEY"
    case badPassword = "error.ble.BAD_PASS"
    case noInternet = "error.ble.NO_INTERNET"
    case noServer = "error.ble.NO_SERVER"
    case failed = "error.ble.FAILED"
  }

  func popupSegueIdentifier() -> PairingStepSegues {
    switch errorType! {
    case .unknown, .disconnected:
      return PairingStepSegues.segueToBLEConnectionLostErrorPopOver
    case .badSSID, .badKey, .badPassword:
      return PairingStepSegues.segueToBLECheckWifiErrorPopover
    case  .noInternet, .noServer:
      return PairingStepSegues.segueToBLEConfigFailedErrorPopOver
    default:
      return PairingStepSegues.segueToBLEConfigFailedErrorPopOver
    }
  }
}
