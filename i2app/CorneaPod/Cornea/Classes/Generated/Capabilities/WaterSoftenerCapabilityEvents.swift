
//
// WaterSoftenerCapEvents.swift
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
  /** Forces a recharge on the water softener. */
  static let waterSoftenerRechargeNow: String = "watersoftener:rechargeNow"
  
}

// MARK: Enumerations

/** Recharge status of the water softener:  READY (providing soft water), RECHARGING (actively regenerating), RECHARGE_SCHEDULED (recharge required and will be done at rechargeStartTime) */
public enum WaterSoftenerRechargeStatus: String {
  case ready = "READY"
  case recharging = "RECHARGING"
  case recharge_scheduled = "RECHARGE_SCHEDULED"
}

// MARK: Requests

/** Forces a recharge on the water softener. */
public class WaterSoftenerRechargeNowRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.waterSoftenerRechargeNow
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
    return WaterSoftenerRechargeNowResponse(message)
  }

  
}

public class WaterSoftenerRechargeNowResponse: SessionEvent {
  
}

