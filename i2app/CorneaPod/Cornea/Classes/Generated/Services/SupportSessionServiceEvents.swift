
//
// SupportSessionServiceEvents.swift
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
  /** Find all active support customer sessions (if any) */
  public static let supportSessionServiceListAllActiveSessions: String = "suppcustsession:ListAllActiveSessions"
  
}

// MARK: Requests

/** Find all active support customer sessions (if any) */
public class SupportSessionServiceListAllActiveSessionsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportSessionServiceListAllActiveSessionsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportSessionServiceListAllActiveSessions
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
    return SupportSessionServiceListAllActiveSessionsResponse(message)
  }
  // MARK: ListAllActiveSessionsRequest Attributes
  struct Attributes {
    /** The maximum number of sessions to return (defaults to 50) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results */
    static let token: String = "token"
 }
  
  /** The maximum number of sessions to return (defaults to 50) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
}

public class SupportSessionServiceListAllActiveSessionsResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The active sessions */
  public func getSessions() -> [Any]? {
    return self.attributes["sessions"] as? [Any]
  }
}

