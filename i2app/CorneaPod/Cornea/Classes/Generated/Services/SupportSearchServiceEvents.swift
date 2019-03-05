
//
// SupportSearchServiceEvents.swift
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
  /** Searches the Elastic Search full text search index */
  public static let supportSearchServiceSupportMainSearch: String = "supportsearch:SupportMainSearch"
  
}

// MARK: Requests

/** Searches the Elastic Search full text search index */
public class SupportSearchServiceSupportMainSearchRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: SupportSearchServiceSupportMainSearchRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.supportSearchServiceSupportMainSearch
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
    return SupportSearchServiceSupportMainSearchResponse(message)
  }
  // MARK: SupportMainSearchRequest Attributes
  struct Attributes {
    /** The string to use for searching */
    static let critera: String = "critera"
/** starting point for results to return */
    static let from: String = "from"
/** total result size to return */
    static let size: String = "size"
 }
  
  /** The string to use for searching */
  public func setCritera(_ critera: String) {
    attributes[Attributes.critera] = critera as AnyObject
  }

  
  /** starting point for results to return */
  public func setFrom(_ from: Any) {
    attributes[Attributes.from] = from as AnyObject
  }

  
  /** total result size to return */
  public func setSize(_ size: Any) {
    attributes[Attributes.size] = size as AnyObject
  }

  
}

public class SupportSearchServiceSupportMainSearchResponse: SessionEvent {
  
}

