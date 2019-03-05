
//
// ProblemDeviceCapEvents.swift
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
  /** Add device(s) having a problem to the db. Normally taken care of by the end session call. */
  static let problemDeviceAddProblemDevices: String = "suppprobdev:AddProblemDevices"
  /** Lists problem devices within a time range across accounts and places */
  static let problemDeviceListProblemDevicesForTimeframe: String = "suppprobdev:ListProblemDevicesForTimeframe"
  
}

// MARK: Enumerations

// MARK: Requests

/** Add device(s) having a problem to the db. Normally taken care of by the end session call. */
public class ProblemDeviceAddProblemDevicesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProblemDeviceAddProblemDevicesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.problemDeviceAddProblemDevices
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
    return ProblemDeviceAddProblemDevicesResponse(message)
  }

  // MARK: AddProblemDevicesRequest Attributes
  struct Attributes {
    /** list of devices */
    static let models: String = "models"
 }
  
  /** list of devices */
  public func setModels(_ models: [Any]) {
    attributes[Attributes.models] = models as AnyObject
  }

  
}

public class ProblemDeviceAddProblemDevicesResponse: SessionEvent {
  
}

/** Lists problem devices within a time range across accounts and places */
public class ProblemDeviceListProblemDevicesForTimeframeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProblemDeviceListProblemDevicesForTimeframeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.problemDeviceListProblemDevicesForTimeframe
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
    return ProblemDeviceListProblemDevicesForTimeframeResponse(message)
  }

  // MARK: ListProblemDevicesForTimeframeRequest Attributes
  struct Attributes {
    /** specific device type to return problem devices for */
    static let deviceModel: String = "deviceModel"
/** manufacturer to return problem devices for */
    static let mfg: String = "mfg"
/** generic device type to return problem devices for */
    static let deviceType: String = "deviceType"
/** Earliest date for problem devices. Format is yyyy-MM-dd HH:mm:ss */
    static let startDate: String = "startDate"
/** Latest date for problem devices. Format is yyyy-MM-dd HH:mm:ss */
    static let endDate: String = "endDate"
/** token for paging results */
    static let token: String = "token"
/** max 1000, default 50 */
    static let limit: String = "limit"
 }
  
  /** specific device type to return problem devices for */
  public func setDeviceModel(_ deviceModel: String) {
    attributes[Attributes.deviceModel] = deviceModel as AnyObject
  }

  
  /** manufacturer to return problem devices for */
  public func setMfg(_ mfg: String) {
    attributes[Attributes.mfg] = mfg as AnyObject
  }

  
  /** generic device type to return problem devices for */
  public func setDeviceType(_ deviceType: String) {
    attributes[Attributes.deviceType] = deviceType as AnyObject
  }

  
  /** Earliest date for problem devices. Format is yyyy-MM-dd HH:mm:ss */
  public func setStartDate(_ startDate: String) {
    attributes[Attributes.startDate] = startDate as AnyObject
  }

  
  /** Latest date for problem devices. Format is yyyy-MM-dd HH:mm:ss */
  public func setEndDate(_ endDate: String) {
    attributes[Attributes.endDate] = endDate as AnyObject
  }

  
  /** token for paging results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
  /** max 1000, default 50 */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
}

public class ProblemDeviceListProblemDevicesForTimeframeResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The list of problem devices */
  public func getProblemDevices() -> [Any]? {
    return self.attributes["problemDevices"] as? [Any]
  }
}

