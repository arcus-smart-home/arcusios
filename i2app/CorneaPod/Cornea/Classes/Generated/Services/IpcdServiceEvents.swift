
//
// IpcdServiceEvents.swift
//
// Generated on 20/09/18
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

import Foundation
// MARK: Commands
fileprivate struct Commands {
  /** Lists the available vendor/model combinations for supported IPCD devices */
  public static let ipcdServiceListDeviceTypes: String = "ipcd:ListDeviceTypes"
  /** Finds the IPCD device for the given vendor/model/sn combination that uniquely identies an IPCD device */
  public static let ipcdServiceFindDevice: String = "ipcd:FindDevice"
  /** Forces unregistration of an IPCD device */
  public static let ipcdServiceForceUnregister: String = "ipcd:ForceUnregister"
  
}

// MARK: Requests

/** Lists the available vendor/model combinations for supported IPCD devices */
public class IpcdServiceListDeviceTypesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.ipcdServiceListDeviceTypes
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IpcdServiceListDeviceTypesResponse(message)
  }
  
}

public class IpcdServiceListDeviceTypesResponse: SessionEvent {
  
  
  /** List of supported IPCD device types */
  public func getDeviceTypes() -> [Any]? {
    return self.attributes["deviceTypes"] as? [Any]
  }
}

/** Finds the IPCD device for the given vendor/model/sn combination that uniquely identies an IPCD device */
public class IpcdServiceFindDeviceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IpcdServiceFindDeviceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ipcdServiceFindDevice
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IpcdServiceFindDeviceResponse(message)
  }
  // MARK: FindDeviceRequest Attributes
  struct Attributes {
    /** The type of device to search for */
    static let deviceType: String = "deviceType"
/** The serial number of the device the user would register with */
    static let sn: String = "sn"
 }
  
  /** The type of device to search for */
  public func setDeviceType(_ deviceType: Any) {
    attributes[Attributes.deviceType] = deviceType as AnyObject
  }

  
  /** The serial number of the device the user would register with */
  public func setSn(_ sn: String) {
    attributes[Attributes.sn] = sn as AnyObject
  }

  
}

public class IpcdServiceFindDeviceResponse: SessionEvent {
  
  
  /** A structure containing the IPCD device information */
  public func getIpcdDevice() -> Any? {
    return self.attributes["ipcdDevice"]
  }
  /** The full device object if the IPCD device is registered */
  public func getDevice() -> Any? {
    return self.attributes["device"]
  }
}

/** Forces unregistration of an IPCD device */
public class IpcdServiceForceUnregisterRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IpcdServiceForceUnregisterRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ipcdServiceForceUnregister
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IpcdServiceForceUnregisterResponse(message)
  }
  // MARK: ForceUnregisterRequest Attributes
  struct Attributes {
    /** The protocol address of the device to forcibly remove */
    static let protocolAddress: String = "protocolAddress"
 }
  
  /** The protocol address of the device to forcibly remove */
  public func setProtocolAddress(_ protocolAddress: String) {
    attributes[Attributes.protocolAddress] = protocolAddress as AnyObject
  }

  
}

public class IpcdServiceForceUnregisterResponse: SessionEvent {
  
}

