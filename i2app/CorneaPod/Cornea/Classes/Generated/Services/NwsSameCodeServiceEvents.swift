
//
// NwsSameCodeServiceEvents.swift
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
  /**  */
  public static let nwsSameCodeServiceListSameCounties: String = "nwssamecode:ListSameCounties"
  /**  */
  public static let nwsSameCodeServiceListSameStates: String = "nwssamecode:ListSameStates"
  /**  */
  public static let nwsSameCodeServiceGetSameCode: String = "nwssamecode:GetSameCode"
  
}

// MARK: Requests

/**  */
public class NwsSameCodeServiceListSameCountiesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: NwsSameCodeServiceListSameCountiesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.nwsSameCodeServiceListSameCounties
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
    return NwsSameCodeServiceListSameCountiesResponse(message)
  }
  // MARK: ListSameCountiesRequest Attributes
  struct Attributes {
    /** 2 or 3 char state or territory postal code from the NWS SAME Code database */
    static let stateCode: String = "stateCode"
 }
  
  /** 2 or 3 char state or territory postal code from the NWS SAME Code database */
  public func setStateCode(_ stateCode: String) {
    attributes[Attributes.stateCode] = stateCode as AnyObject
  }

  
}

public class NwsSameCodeServiceListSameCountiesResponse: SessionEvent {
  
  
  /**  */
  public func getCounties() -> [String]? {
    return self.attributes["counties"] as? [String]
  }
}

/**  */
public class NwsSameCodeServiceListSameStatesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.nwsSameCodeServiceListSameStates
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
    return NwsSameCodeServiceListSameStatesResponse(message)
  }
  
}

public class NwsSameCodeServiceListSameStatesResponse: SessionEvent {
  
  
  /**  */
  public func getSameStates() -> [Any]? {
    return self.attributes["sameStates"] as? [Any]
  }
}

/**  */
public class NwsSameCodeServiceGetSameCodeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: NwsSameCodeServiceGetSameCodeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.nwsSameCodeServiceGetSameCode
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
    return NwsSameCodeServiceGetSameCodeResponse(message)
  }
  // MARK: GetSameCodeRequest Attributes
  struct Attributes {
    /** 2 or 3 char state or territory postal code from the NWS SAME Code database */
    static let stateCode: String = "stateCode"
/** county name specific to weather station as listed in the NWS SAME Code database */
    static let county: String = "county"
 }
  
  /** 2 or 3 char state or territory postal code from the NWS SAME Code database */
  public func setStateCode(_ stateCode: String) {
    attributes[Attributes.stateCode] = stateCode as AnyObject
  }

  
  /** county name specific to weather station as listed in the NWS SAME Code database */
  public func setCounty(_ county: String) {
    attributes[Attributes.county] = county as AnyObject
  }

  
}

public class NwsSameCodeServiceGetSameCodeResponse: SessionEvent {
  
  
  /**  */
  public func getCode() -> String? {
    return self.attributes["code"] as? String
  }
}

