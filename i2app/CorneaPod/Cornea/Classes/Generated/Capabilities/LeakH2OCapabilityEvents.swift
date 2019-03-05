
//
// LeakH2OCapEvents.swift
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
  static let leakH2OLeakh2o: String = "leakh2o:leakh2o"
  
}

// MARK: Enumerations

/** Reflects the state of the leak detector. */
public enum LeakH2OState: String {
  case safe = "SAFE"
  case leak = "LEAK"
}

// MARK: Requests

/**  */
public class LeakH2OLeakh2oRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LeakH2OLeakh2oRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.leakH2OLeakh2o
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
    return LeakH2OLeakh2oResponse(message)
  }

  // MARK: leakh2oRequest Attributes
  struct Attributes {
    /**  */
    static let state: String = "state"
 }
  
  /**  */
  public func setState(_ state: String) {
    attributes[Attributes.state] = state as AnyObject
  }

  
}

public class LeakH2OLeakh2oResponse: SessionEvent {
  
}

